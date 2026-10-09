/**
 * XƯỞNG VẼ HÌNH HỌC TƯƠNG TÁC (LAB) - v2.4
 * Giai đoạn 1: Khung trang, khởi tạo bảng vẽ SVG, kết nối /api/lab/meta và xử lý lỗi Neo4j.
 */

(function () {
    'use strict';

    // SVG icon mini cho 8 hình mẫu cơ bản
    const PRESET_ICONS = {
        'tu-giac': '<svg viewBox="0 0 100 70"><path d="M15 15 L85 10 L80 60 L20 55 Z" fill="none" stroke="#1F3A93" stroke-width="3"/></svg>',
        'hinh-thang': '<svg viewBox="0 0 100 70"><path d="M25 15 L75 15 L90 55 L10 55 Z" fill="none" stroke="#1F3A93" stroke-width="3"/></svg>',
        'hinh-thang-can': '<svg viewBox="0 0 100 70"><path d="M25 15 L75 15 L85 55 L15 55 Z" fill="none" stroke="#1F3A93" stroke-width="3"/></svg>',
        'hinh-binh-hanh': '<svg viewBox="0 0 100 70"><path d="M30 15 L90 15 L70 55 L10 55 Z" fill="none" stroke="#1F3A93" stroke-width="3"/></svg>',
        'hinh-chu-nhat': '<svg viewBox="0 0 100 70"><path d="M15 15 L85 15 L85 55 L15 55 Z" fill="none" stroke="#1F3A93" stroke-width="3"/></svg>',
        'hinh-thoi': '<svg viewBox="0 0 100 70"><path d="M50 10 L85 35 L50 60 L15 35 Z" fill="none" stroke="#1F3A93" stroke-width="3"/></svg>',
        'hinh-vuong': '<svg viewBox="0 0 100 70"><path d="M20 10 L80 10 L80 60 L20 60 Z" fill="none" stroke="#1F3A93" stroke-width="3"/></svg>',
        'hinh-dieu': '<svg viewBox="0 0 100 70"><path d="M50 10 L80 30 L50 62 L20 30 Z" fill="none" stroke="#1F3A93" stroke-width="3"/></svg>'
    };

    // State ứng dụng
    const state = {
        meta: null,
        activePreset: 'hinh-chu-nhat',
        mode: 'param', // 'param' | 'free'
        snap: true,
        snapStep: 1, // 1 | 0.5 | 0
        layers: {
            sides: true,
            angles: true,
            diagonals: true,
            marks: true
        },
        zoom: 1,
        pan: { x: 80, y: 380 } // Gốc tọa độ ban đầu (dưới-trái)
    };

    // Khởi tạo ứng dụng khi DOM sẵn sàng
    document.addEventListener('DOMContentLoaded', initLab);

    async function initLab() {
        bindToolbarEvents();
        bindSidebarTabs();
        initSvgAxes();
        await loadLabMeta();
    }

    /**
     * Tải siêu dữ liệu hình học từ Neo4j qua /api/lab/meta
     */
    async function loadLabMeta() {
        const loadingText = document.getElementById('labPresetLoadingText');
        const scrollContainer = document.getElementById('labPresetScroll');
        const errorContainer = document.getElementById('labPresetErrorContainer');
        const statusText = document.getElementById('labStatusText');

        if (loadingText) loadingText.style.display = 'inline';
        if (errorContainer) errorContainer.style.display = 'none';

        try {
            const res = await fetch('/api/lab/meta');
            if (!res.ok) {
                throw new Error(`HTTP ${res.status}: Máy chủ không thể nạp siêu dữ liệu`);
            }
            const data = await res.json();
            state.meta = data;

            if (loadingText) loadingText.style.display = 'none';
            renderPresetButtons(data.shapes || []);

            if (statusText) {
                statusText.textContent = 'Hình chữ nhật (cũng là hình bình hành, hình thang cân, hình thang, tứ giác)';
            }
        } catch (err) {
            console.error('Lỗi nạp /api/lab/meta:', err);
            if (loadingText) loadingText.style.display = 'none';
            if (scrollContainer) scrollContainer.innerHTML = '';
            
            // Xử lý lỗi thân thiện theo Mục 3 và Mục 0 của tài liệu
            if (errorContainer) {
                errorContainer.style.display = 'block';
                errorContainer.innerHTML = `
                    <div class="lab-error-card">
                        <h4 style="font-family: 'Patrick Hand', cursive; font-size: 1.4rem;">⚠️ Không tải được dữ liệu hình mẫu</h4>
                        <p class="mb-2">Hệ thống không thể kết nối tới cơ sở dữ liệu Neo4j để lấy thông tin các hình và công thức.</p>
                        <button type="button" class="btn-pen" id="labBtnRetry">↺ Thử lại</button>
                    </div>
                `;
                const btnRetry = document.getElementById('labBtnRetry');
                if (btnRetry) {
                    btnRetry.addEventListener('click', loadLabMeta);
                }
            }

            if (statusText) {
                statusText.textContent = 'Bảng vẽ hoạt động ở chế độ độc lập (Chưa tải được dữ liệu Neo4j)';
            }
        }
    }

    /**
     * Hiển thị danh sách nút chọn hình mẫu
     */
    function renderPresetButtons(shapes) {
        const container = document.getElementById('labPresetScroll');
        if (!container) return;

        container.innerHTML = '';
        shapes.forEach(s => {
            const btn = document.createElement('button');
            btn.type = 'button';
            btn.className = `lab-preset-btn ${s.slug === state.activePreset ? 'active' : ''}`;
            btn.setAttribute('data-slug', s.slug);
            btn.setAttribute('role', 'tab');
            btn.setAttribute('aria-selected', s.slug === state.activePreset ? 'true' : 'false');
            btn.title = `Chọn hình mẫu: ${s.name}`;

            const iconHtml = PRESET_ICONS[s.slug] || PRESET_ICONS['tu-giac'];
            btn.innerHTML = `
                ${iconHtml}
                <span class="lab-preset-label">${s.name}</span>
            `;

            btn.addEventListener('click', () => {
                selectPreset(s.slug);
            });

            container.appendChild(btn);
        });
    }

    /**
     * Chọn một hình mẫu
     */
    function selectPreset(slug) {
        state.activePreset = slug;
        document.querySelectorAll('.lab-preset-btn').forEach(btn => {
            const isMatch = btn.getAttribute('data-slug') === slug;
            btn.classList.toggle('active', isMatch);
            btn.setAttribute('aria-selected', isMatch ? 'true' : 'false');
        });

        const alertMsg = document.getElementById('labAlertMessage');
        if (alertMsg) {
            const shapeObj = state.meta?.shapes?.find(s => s.slug === slug);
            const shapeName = shapeObj ? shapeObj.name : slug;
            alertMsg.textContent = `Đã chọn hình mẫu: ${shapeName}. Có thể kéo đỉnh để thay đổi kích thước.`;
        }
    }

    /**
     * Gắn sự kiện thanh công cụ
     */
    function bindToolbarEvents() {
        // Chuyển chế độ: Theo hình mẫu vs Tự do
        const modePresetBtn = document.getElementById('labModePresetBtn');
        const modeFreeBtn = document.getElementById('labModeFreeBtn');
        if (modePresetBtn && modeFreeBtn) {
            modePresetBtn.addEventListener('click', () => {
                state.mode = 'param';
                modePresetBtn.classList.add('active');
                modeFreeBtn.classList.remove('active');
            });
            modeFreeBtn.addEventListener('click', () => {
                state.mode = 'free';
                modeFreeBtn.classList.add('active');
                modePresetBtn.classList.remove('active');
            });
        }

        // Bắt lưới & bước
        const snapCheck = document.getElementById('labSnapCheck');
        if (snapCheck) {
            snapCheck.addEventListener('change', (e) => {
                state.snap = e.target.checked;
            });
        }
        const snapStepSelect = document.getElementById('labSnapStepSelect');
        if (snapStepSelect) {
            snapStepSelect.addEventListener('change', (e) => {
                state.snapStep = parseFloat(e.target.value);
            });
        }

        // Các lớp hiển thị
        ['Sides', 'Angles', 'Diagonals', 'Marks'].forEach(layer => {
            const chk = document.getElementById(`labLayer${layer}`);
            if (chk) {
                chk.addEventListener('change', (e) => {
                    const key = layer.toLowerCase();
                    state.layers[key] = e.target.checked;
                });
            }
        });

        // Nút chia sẻ URL
        const btnShare = document.getElementById('labBtnShare');
        if (btnShare) {
            btnShare.addEventListener('click', () => {
                const url = new URL(window.location.href);
                url.searchParams.set('shape', state.activePreset);
                url.searchParams.set('mode', state.mode);
                navigator.clipboard.writeText(url.toString()).then(() => {
                    alert('✓ Đã sao chép liên kết vào bộ nhớ tạm: ' + url.toString());
                }).catch(() => {
                    prompt('Sao chép liên kết này:', url.toString());
                });
            });
        }

        // Nút zoom & vừa khung
        const btnZoomIn = document.getElementById('labBtnZoomIn');
        const btnZoomOut = document.getElementById('labBtnZoomOut');
        const btnZoomFit = document.getElementById('labBtnZoomFit');
        if (btnZoomIn) {
            btnZoomIn.addEventListener('click', () => {
                state.zoom = Math.min(2.0, state.zoom + 0.1);
                applyTransform();
            });
        }
        if (btnZoomOut) {
            btnZoomOut.addEventListener('click', () => {
                state.zoom = Math.max(0.5, state.zoom - 0.1);
                applyTransform();
            });
        }
        if (btnZoomFit) {
            btnZoomFit.addEventListener('click', () => {
                state.zoom = 1;
                state.pan = { x: 80, y: 380 };
                applyTransform();
            });
        }
    }

    /**
     * Gắn sự kiện chuyển tab bên phải
     */
    function bindSidebarTabs() {
        const tabButtons = document.querySelectorAll('.lab-tab-btn');
        tabButtons.forEach(btn => {
            btn.addEventListener('click', () => {
                const targetTab = btn.getAttribute('data-tab');
                tabButtons.forEach(b => b.classList.remove('active'));
                btn.classList.add('active');

                document.querySelectorAll('.lab-tab-pane').forEach(pane => {
                    pane.classList.remove('active');
                });
                const activePane = document.getElementById(targetTab);
                if (activePane) {
                    activePane.classList.add('active');
                }
            });
        });
    }

    /**
     * Khởi tạo hệ trục tọa độ toán học (gốc dưới-trái, đánh số mỗi 5 ô)
     */
    function initSvgAxes() {
        const axesGroup = document.getElementById('labAxesGroup');
        if (!axesGroup) return;

        axesGroup.innerHTML = '';

        // Trục hoành Ox và Trục tung Oy
        const axisLines = document.createElementNS('http://www.w3.org/2000/svg', 'path');
        axisLines.setAttribute('d', 'M 0 0 L 600 0 M 0 0 L 0 -350');
        axisLines.setAttribute('stroke', '#3B3F46');
        axisLines.setAttribute('stroke-width', '1.5');
        axesGroup.appendChild(axisLines);

        // Mũi tên Ox
        const arrowX = document.createElementNS('http://www.w3.org/2000/svg', 'path');
        arrowX.setAttribute('d', 'M 595 -4 L 602 0 L 595 4');
        arrowX.setAttribute('stroke', '#3B3F46');
        arrowX.setAttribute('stroke-width', '1.5');
        arrowX.setAttribute('fill', 'none');
        axesGroup.appendChild(arrowX);

        // Mũi tên Oy
        const arrowY = document.createElementNS('http://www.w3.org/2000/svg', 'path');
        arrowY.setAttribute('d', 'M -4 -345 L 0 -352 L 4 -345');
        arrowY.setAttribute('stroke', '#3B3F46');
        arrowY.setAttribute('stroke-width', '1.5');
        arrowY.setAttribute('fill', 'none');
        axesGroup.appendChild(arrowY);

        // Nhãn trục x, y, O
        addSvgText(axesGroup, 608, 4, 'x (cm)', '#3B3F46', '12px', 'start');
        addSvgText(axesGroup, 0, -360, 'y (cm)', '#3B3F46', '12px', 'middle');
        addSvgText(axesGroup, -10, 15, 'O', '#3B3F46', '12px', 'end');

        // Vạch và số mỗi 5 ô (1 ô = 24px)
        for (let i = 5; i <= 20; i += 5) {
            const px = i * 24;
            // Vạch x
            const tickX = document.createElementNS('http://www.w3.org/2000/svg', 'line');
            tickX.setAttribute('x1', px);
            tickX.setAttribute('y1', -3);
            tickX.setAttribute('x2', px);
            tickX.setAttribute('y2', 3);
            tickX.setAttribute('stroke', '#3B3F46');
            axesGroup.appendChild(tickX);
            addSvgText(axesGroup, px, 16, i.toString(), '#3B3F46', '11px', 'middle');

            // Vạch y
            const py = -i * 24;
            const tickY = document.createElementNS('http://www.w3.org/2000/svg', 'line');
            tickY.setAttribute('x1', -3);
            tickY.setAttribute('y1', py);
            tickY.setAttribute('x2', 3);
            tickY.setAttribute('y2', py);
            tickY.setAttribute('stroke', '#3B3F46');
            axesGroup.appendChild(tickY);
            addSvgText(axesGroup, -8, py + 4, i.toString(), '#3B3F46', '11px', 'end');
        }

        applyTransform();
    }

    function addSvgText(parent, x, y, text, color, fontSize, textAnchor) {
        const t = document.createElementNS('http://www.w3.org/2000/svg', 'text');
        t.setAttribute('x', x);
        t.setAttribute('y', y);
        t.setAttribute('fill', color);
        t.setAttribute('font-size', fontSize);
        t.setAttribute('font-family', "'Be Vietnam Pro', sans-serif");
        t.setAttribute('text-anchor', textAnchor || 'start');
        t.textContent = text;
        parent.appendChild(t);
        return t;
    }

    function applyTransform() {
        const scene = document.getElementById('labSceneGroup');
        if (!scene) return;
        scene.setAttribute('transform', `translate(${state.pan.x}, ${state.pan.y}) scale(${state.zoom})`);
    }

})();
