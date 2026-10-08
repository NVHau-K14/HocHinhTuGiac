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
        networkInstance.fit();
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

    // Chuẩn bị dữ liệu Nodes
    const visNodes = data.nodes.map(n => ({
        id: n.id,
        label: n.label,
        level: 4 - n.level, // Đảo để Tứ giác ở tầng cao nhất (level 4), vuông ở đáy (level 0)
        shape: 'box',
        margin: { top: 8, bottom: 8, left: 14, right: 14 },
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
            size: 19,
            color: '#1F3A93'
        },
        shadow: false
    }));

    // Chuẩn bị dữ liệu Edges (from: con, to: cha, mũi tên chỉ lên hình cha)
    const visEdges = data.edges.map(e => ({
        from: e.from,
        to: e.to,
        label: 'IS_A',
        arrows: {
            to: { enabled: true, scaleFactor: 0.8 }
        },
        color: {
            color: '#1F3A93',
            highlight: '#D64550'
        },
        font: {
            face: 'Be Vietnam Pro',
            size: 11,
            color: '#D64550',
            align: 'middle'
        },
        smooth: {
            type: 'cubicBezier',
            forceDirection: 'vertical',
            roundness: 0.3
        }
    }));

    const networkData = {
        nodes: new vis.DataSet(visNodes),
        edges: new vis.DataSet(visEdges)
    };

    const options = {
        layout: {
            hierarchical: {
                enabled: true,
                direction: 'DU', // Down-Up: Mũi tên từ con hướng lên hình cha
                sortMethod: 'directed',
                levelSeparation: 95,
                nodeSpacing: 140
            }
        },
        interaction: {
            dragNodes: true,
            dragView: true,
            zoomView: true,
            hover: true
        },
        physics: false
    };

    networkInstance = new vis.Network(container, networkData, options);

    // Bấm vào node sẽ chuyển hướng tới trang chi tiết hình
    networkInstance.on('click', function (params) {
        if (params.nodes && params.nodes.length > 0) {
            const clickedId = params.nodes[0];
            window.location.href = '/shape/' + clickedId;
        }
    });

    setTimeout(() => {
        if (networkInstance) networkInstance.fit();
    }, 200);
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
