// ==========================================================================
// VIS-NETWORK GRAPH VIEWER (PBI-11)
// Lazy load CDN chỉ khi người dùng bấm nút "Xem sơ đồ quan hệ"
// ==========================================================================

let networkInstance = null;
let graphDataCache = null;

function openGraphModal() {
    const modal = document.getElementById('graphModal');
    if (!modal) return;

    modal.style.display = 'flex';
    document.body.style.overflow = 'hidden';

    // Đã có dữ liệu và mạng đã vẽ
    if (networkInstance && graphDataCache) {
        setTimeout(() => {
            if (networkInstance) networkInstance.fit({ animation: false });
        }, 60);
        return;
    }

    loadGraph();
}

function closeGraphModal() {
    const modal = document.getElementById('graphModal');
    if (!modal) return;

    modal.style.display = 'none';
    document.body.style.overflow = 'auto';
}

function loadGraph() {
    const loadingEl = document.getElementById('graphLoading');
    const errorEl = document.getElementById('graphError');
    const container = document.getElementById('visNetworkContainer');

    if (loadingEl) loadingEl.style.display = 'block';
    if (errorEl) errorEl.style.display = 'none';

    // 1. Nạp thư viện vis-network từ CDN nếu chưa có
    loadVisScript(function (err) {
        if (err) {
            if (loadingEl) loadingEl.style.display = 'none';
            if (errorEl) errorEl.style.display = 'block';
            return;
        }

        // 2. Gọi API /api/graph
        fetch('/api/graph')
            .then(res => {
                if (!res.ok) throw new Error('Không thể tải dữ liệu từ máy chủ');
                return res.json();
            })
            .then(data => {
                if (loadingEl) loadingEl.style.display = 'none';
                graphDataCache = data;
                renderVisNetwork(container, data);
            })
            .catch(e => {
                console.error(e);
                if (loadingEl) loadingEl.style.display = 'none';
                if (errorEl) errorEl.style.display = 'block';
            });
    });
}

function loadVisScript(callback) {
    if (window.vis && window.vis.Network) {
        callback(null);
        return;
    }

    const script = document.createElement('script');
    script.src = 'https://unpkg.com/vis-network/standalone/umd/vis-network.min.js';
    script.async = true;
    script.onload = () => callback(null);
    script.onerror = () => callback(new Error('Lỗi nạp script vis-network'));
    document.head.appendChild(script);
}

function renderVisNetwork(container, data) {
    if (!container || !window.vis) return;

    // Tọa độ đối xứng hình học cho 8 hình (Tứ giác ở đỉnh, Hình vuông ở đáy)
    // Giúp các nhánh phân lập rõ ràng, không có bất kỳ nhãn nào đè nhau
    const nodeCoords = {
        'tu-giac':        { x: 0,    y: 0 },
        'hinh-thang':     { x: -240, y: 150 },
        'hinh-dieu':      { x: 240,  y: 150 },
        'hinh-thang-can': { x: -340, y: 310 },
        'hinh-binh-hanh': { x: 0,    y: 310 },
        'hinh-chu-nhat':  { x: -180, y: 470 },
        'hinh-thoi':      { x: 180,  y: 470 },
        'hinh-vuong':     { x: 0,    y: 630 }
    };

    // Chuẩn bị dữ liệu Nodes
    const visNodes = data.nodes.map(n => {
        const coords = nodeCoords[n.id] || { x: 0, y: n.level * 150 };
        return {
            id: n.id,
            label: n.label,
            x: coords.x,
            y: coords.y,
            shape: 'box',
            margin: { top: 9, bottom: 9, left: 16, right: 16 },
            color: {
                background: n.color || '#FAFCFD',
                border: '#1F3A93',
                highlight: {
                    background: '#FFE66D',
                    border: '#D64550'
                }
            },
            borderWidth: 2,
            font: {
                face: 'Patrick Hand',
                size: 16, // Cỡ chữ >= 15px
                color: '#1F3A93'
            },
            shadow: false
        };
    });

    // Chuẩn bị dữ liệu Edges:
    // Mặc định "Thêm điều kiện": Mũi tên đi từ hình cha xuống hình con (e.to -> e.from)
    // Nhãn: "+ điều kiện", nằm ngang, nền dạ quang #FFE66D, cỡ chữ 13px
    const visEdges = data.edges.map((e, index) => {
        const condText = e.conditionShort || e.condition || '';
        const edgeLabel = condText ? `+ ${condText}` : '';

        return {
            id: `edge_${e.from}_${e.to}`,
            from: e.to,    // Hình cha (tổng quát hơn, ở trên)
            to: e.from,    // Hình con (đặc biệt hơn, ở dưới)
            childSlug: e.from,
            parentSlug: e.to,
            label: edgeLabel,
            arrows: {
                to: { enabled: true, scaleFactor: 1.0 }
            },
            width: 2,
            selectionWidth: 4,
            hoverWidth: 3,
            color: {
                color: '#1F3A93',
                highlight: '#D64550',
                hover: '#D64550'
            },
            font: {
                face: 'Be Vietnam Pro',
                size: 13,
                color: '#1F3A93',
                background: '#FFE66D',
                strokeWidth: 0,
                align: 'horizontal' // Nằm ngang, không xoay theo đường cong
            },
            smooth: {
                type: 'cubicBezier',
                forceDirection: 'vertical',
                roundness: 0.32
            }
        };
    });

    const networkData = {
        nodes: new vis.DataSet(visNodes),
        edges: new vis.DataSet(visEdges)
    };

    const options = {
        interaction: {
            dragNodes: true,
            dragView: true,
            zoomView: true,
            hover: true
        },
        physics: false
    };

    networkInstance = new vis.Network(container, networkData, options);

    // Bấm vào node sẽ chuyển hướng tới bài học hình học
    networkInstance.on('click', function (params) {
        if (params.nodes && params.nodes.length > 0) {
            const clickedId = params.nodes[0];
            window.location.href = '/shapes/' + clickedId;
        }
    });

    // Fit canvas lấp đầy khung sau khi vẽ xong
    setTimeout(() => {
        if (networkInstance) {
            networkInstance.fit({ animation: false });
        }
    }, 150);
}

// Bắt sự kiện khi DOM tải xong
document.addEventListener('DOMContentLoaded', function () {
    // Nút mở modal
    document.querySelectorAll('[data-action="open-graph"]').forEach(btn => {
        btn.addEventListener('click', function (e) {
            e.preventDefault();
            openGraphModal();
        });
    });

    const btnOpenGraph = document.getElementById('btnOpenGraph');
    if (btnOpenGraph) {
        btnOpenGraph.addEventListener('click', function (e) {
            e.preventDefault();
            openGraphModal();
        });
    }

    // Nút đóng modal
    const btnClose = document.getElementById('btnCloseGraph');
    if (btnClose) {
        btnClose.addEventListener('click', closeGraphModal);
    }

    // Thử lại khi lỗi
    const btnRetry = document.getElementById('btnRetryGraph');
    if (btnRetry) {
        btnRetry.addEventListener('click', loadGraph);
    }

    // Đóng khi click ngoài backdrop
    const modal = document.getElementById('graphModal');
    if (modal) {
        modal.addEventListener('click', function (e) {
            if (e.target === modal) {
                closeGraphModal();
            }
        });
    }

    // Đóng bằng phím Escape
    document.addEventListener('keydown', function (e) {
        if (e.key === 'Escape') {
            closeGraphModal();
        }
    });
});
