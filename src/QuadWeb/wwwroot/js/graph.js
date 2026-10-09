// ==========================================================================
// VIS-NETWORK GRAPH VIEWER (PBI-11 / v2.3)
// Lazy load CDN chỉ khi người dùng bấm nút "Xem sơ đồ quan hệ"
// ==========================================================================

let networkInstance = null;
let graphDataCache = null;
let currentGraphMode = 'condition'; // 'condition' (Thêm điều kiện) hoặc 'is_a' (Theo IS_A)
let selectedEdgeId = null;
let nodesDataSet = null;
let edgesDataSet = null;

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

    resetGraphHighlight();
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

// Xây dựng danh sách cạnh hiển thị theo chế độ đọc
function buildVisEdges(edgesRaw, mode) {
    return edgesRaw.map(e => {
        let from, to, label;
        if (mode === 'is_a') {
            // Chiều: Hình con -> Hình cha (IS_A)
            from = e.from; // slug con
            to = e.to;     // slug cha
            label = `là ${e.toName ? e.toName.toLowerCase() : 'hình cha'}`;
        } else {
            // Chiều: Hình cha -> Hình con (+ điều kiện cần thêm)
            from = e.to;   // slug cha
            to = e.from;   // slug con
            const condText = e.conditionShort || e.condition || '';
            label = condText ? `+ ${condText}` : '';
        }

        return {
            id: `edge_${e.from}_${e.to}`,
            from: from,
            to: to,
            childSlug: e.from,
            parentSlug: e.to,
            fromName: e.fromName,
            toName: e.toName,
            condition: e.condition,
            conditionShort: e.conditionShort,
            label: label,
            arrows: {
                to: { enabled: true, scaleFactor: 1.0 }
            },
            width: 2.2,
            selectionWidth: 5,
            hoverWidth: 3.5,
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
                align: 'horizontal' // Nhãn luôn nằm ngang
            },
            smooth: {
                type: 'cubicBezier',
                forceDirection: 'vertical',
                roundness: 0.32
            }
        };
    });
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
            originalBg: n.color || '#FAFCFD',
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

    const visEdges = buildVisEdges(data.edges, currentGraphMode);

    nodesDataSet = new vis.DataSet(visNodes);
    edgesDataSet = new vis.DataSet(visEdges);

    const networkData = {
        nodes: nodesDataSet,
        edges: edgesDataSet
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

    // Xử lý sự kiện hover đổi con trỏ dạng pointer
    networkInstance.on('hoverEdge', function () {
        container.style.cursor = 'pointer';
    });
    networkInstance.on('blurEdge', function () {
        container.style.cursor = 'default';
    });
    networkInstance.on('hoverNode', function () {
        container.style.cursor = 'pointer';
    });
    networkInstance.on('blurNode', function () {
        container.style.cursor = 'default';
    });

    // Bấm vào node hoặc cạnh
    networkInstance.on('click', function (params) {
        if (params.nodes && params.nodes.length > 0) {
            // 1. Bấm vào HÌNH: Mở bài học chi tiết như cũ
            const clickedId = params.nodes[0];
            window.location.href = '/shapes/' + clickedId;
        } else if (params.edges && params.edges.length > 0) {
            // 2. Bấm vào CẠNH (hoặc nhãn cạnh): Chọn cạnh, tô nổi và làm mờ phần còn lại
            const edgeId = params.edges[0];
            highlightSelectedEdge(edgeId);
        } else {
            // 3. Bấm ra ngoài khoảng trống canvas: Bỏ chọn, khôi phục bình thường
            resetGraphHighlight();
        }
    });

    // Fit canvas lấp đầy khung sau khi vẽ xong
    setTimeout(() => {
        if (networkInstance) {
            networkInstance.fit({ animation: false });
        }
    }, 150);
}

// Chuyển đổi giữa 2 chiều đọc sơ đồ (Mục 3.2)
function setGraphMode(mode) {
    if (currentGraphMode === mode) return;
    currentGraphMode = mode;

    const btnCondition = document.getElementById('btnModeCondition');
    const btnIsA = document.getElementById('btnModeIsA');
    const descEl = document.getElementById('graphModalDesc');
    const hintEl = document.getElementById('graphModeHint');

    if (mode === 'is_a') {
        if (btnCondition) {
            btnCondition.classList.remove('active');
            btnCondition.setAttribute('aria-checked', 'false');
        }
        if (btnIsA) {
            btnIsA.classList.add('active');
            btnIsA.setAttribute('aria-checked', 'true');
        }
        if (descEl) {
            descEl.textContent = 'Mũi tên đi từ hình đặc biệt lên hình tổng quát. Chữ trên mũi tên cho biết hình con là trường hợp của hình cha nào. Bấm vào mũi tên để xem giải thích chi tiết; bấm vào hình để mở bài học.';
        }
        if (hintEl) {
            hintEl.textContent = 'Đang xem: Hình con → Hình cha (quan hệ IS_A)';
        }
    } else {
        if (btnCondition) {
            btnCondition.classList.add('active');
            btnCondition.setAttribute('aria-checked', 'true');
        }
        if (btnIsA) {
            btnIsA.classList.remove('active');
            btnIsA.setAttribute('aria-checked', 'false');
        }
        if (descEl) {
            descEl.textContent = 'Mũi tên đi từ hình tổng quát đến hình đặc biệt. Chữ trên mũi tên là điều kiện cần thêm. Bấm vào mũi tên để xem vì sao hai hình có quan hệ; bấm vào hình để mở bài học.';
        }
        if (hintEl) {
            hintEl.textContent = 'Đang xem: Hình cha → Hình con (kèm điều kiện)';
        }
    }

    // Tái cấu trúc danh sách cạnh
    if (edgesDataSet && graphDataCache) {
        resetGraphHighlight();
        const newEdges = buildVisEdges(graphDataCache.edges, currentGraphMode);
        edgesDataSet.clear();
        edgesDataSet.add(newEdges);
    }
}

// Tô nổi cạnh được chọn và làm mờ các hình/cạnh khác (Mục 3.4)
function highlightSelectedEdge(edgeId) {
    selectedEdgeId = edgeId;
    if (!edgesDataSet || !nodesDataSet) return;

    const edge = edgesDataSet.get(edgeId);
    if (!edge) return;

    const endNode1 = edge.from;
    const endNode2 = edge.to;

    // 1. Cập nhật Edges: cạnh được chọn tô Lề đỏ #D64550 dày, các cạnh khác mờ đi
    const allEdges = edgesDataSet.get();
    const edgeUpdates = allEdges.map(e => {
        if (e.id === edgeId) {
            return {
                id: e.id,
                color: { color: '#D64550', highlight: '#D64550', hover: '#D64550' },
                width: 4.5,
                font: {
                    color: '#ffffff',
                    background: '#D64550',
                    face: 'Be Vietnam Pro',
                    size: 13,
                    strokeWidth: 0,
                    align: 'horizontal'
                }
            };
        } else {
            return {
                id: e.id,
                color: { color: 'rgba(31, 58, 147, 0.16)', highlight: 'rgba(31, 58, 147, 0.16)' },
                width: 1.5,
                font: {
                    color: 'rgba(31, 58, 147, 0.28)',
                    background: 'rgba(255, 230, 109, 0.25)',
                    face: 'Be Vietnam Pro',
                    size: 13,
                    strokeWidth: 0,
                    align: 'horizontal'
                }
            };
        }
    });
    edgesDataSet.update(edgeUpdates);

    // 2. Cập nhật Nodes: 2 node ở 2 đầu có viền đậm, các node khác mờ đi
    const allNodes = nodesDataSet.get();
    const nodeUpdates = allNodes.map(n => {
        if (n.id === endNode1 || n.id === endNode2) {
            return {
                id: n.id,
                borderWidth: 3.5,
                color: {
                    border: '#D64550',
                    background: n.originalBg || '#FAFCFD',
                    highlight: { border: '#D64550', background: n.originalBg || '#FAFCFD' }
                },
                font: { face: 'Patrick Hand', size: 17, color: '#1F3A93' }
            };
        } else {
            return {
                id: n.id,
                borderWidth: 1,
                color: {
                    border: 'rgba(31, 58, 147, 0.25)',
                    background: '#F8FAFC',
                    highlight: { border: 'rgba(31, 58, 147, 0.25)', background: '#F8FAFC' }
                },
                font: { face: 'Patrick Hand', size: 15, color: 'rgba(31, 58, 147, 0.28)' }
            };
        }
    });
    nodesDataSet.update(nodeUpdates);
}

// Bỏ chọn cạnh, khôi phục màu sắc ban đầu (Mục 3.4)
function resetGraphHighlight() {
    selectedEdgeId = null;
    if (!edgesDataSet || !nodesDataSet || !graphDataCache) return;

    // Khôi phục Edges
    const newEdges = buildVisEdges(graphDataCache.edges, currentGraphMode);
    edgesDataSet.clear();
    edgesDataSet.add(newEdges);

    // Khôi phục Nodes
    const allNodes = nodesDataSet.get();
    const nodeUpdates = allNodes.map(n => ({
        id: n.id,
        borderWidth: 2,
        color: {
            background: n.originalBg || '#FAFCFD',
            border: '#1F3A93',
            highlight: { background: '#FFE66D', border: '#D64550' }
        },
        font: { face: 'Patrick Hand', size: 16, color: '#1F3A93' }
    }));
    nodesDataSet.update(nodeUpdates);
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

    // Nút chuyển chiều đọc
    const btnCondition = document.getElementById('btnModeCondition');
    if (btnCondition) {
        btnCondition.addEventListener('click', () => setGraphMode('condition'));
    }

    const btnIsA = document.getElementById('btnModeIsA');
    if (btnIsA) {
        btnIsA.addEventListener('click', () => setGraphMode('is_a'));
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

    // Tự động căn vừa khung hình khi resize cửa sổ
    window.addEventListener('resize', function () {
        if (networkInstance) {
            networkInstance.fit({ animation: false });
        }
    });
});
