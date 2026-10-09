/**
 * XƯỞNG VẼ HÌNH HỌC TƯƠNG TÁC (LAB) - v2.4
 * Giai đoạn 4: Chế độ hình mẫu với tay nắm chuyên biệt, nút mở khóa tự do,
 * ô nhập số hai chiều, tab Công thức (KaTeX thay số & kiểm chứng chéo) và tab Nhận dạng.
 */

(function () {
    'use strict';

    // Import các module lõi từ QuadLab namespace
    const Geometry = window.QuadLab?.Geometry;
    const Presets = window.QuadLab?.Presets;
    const Classify = window.QuadLab?.Classify;
    const Formulas = window.QuadLab?.Formulas;
    const Transform = window.QuadLab?.Transform;
    const UrlSync = window.QuadLab?.UrlSync;

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

    const VERTEX_NAMES = ['A', 'B', 'C', 'D'];

    // State ứng dụng
    const state = {
        meta: null,
        activePreset: 'hinh-chu-nhat',
        mode: 'param', // 'param' (theo hình mẫu) | 'free' (tự do)
        params: { a: 6, b: 4 },
        vertices: [
            { x: 0, y: 0 },
            { x: 6, y: 0 },
            { x: 6, y: 4 },
            { x: 0, y: 4 }
        ],
        snap: true,
        snapStep: 1, // 1 | 0.5 | 0
        layers: {
            sides: true,
            angles: true,
            diagonals: true,
            marks: true,
            axessym: false
        },
        zoom: 1,
        pan: { x: 260, y: 280 }, // Căn giữa bảng vẽ
        history: {
            undo: [],
            redo: []
        },
        drag: {
            active: false,
            vertexIndex: -1,
            pointerId: null,
            startX: 0,
            startY: 0
        },
        currentClassification: null,
        debounceTimer: null
    };

    document.addEventListener('DOMContentLoaded', initLab);

    async function initLab() {
        bindToolbarEvents();
        bindSidebarTabs();
        initSvgAxes();
        bindCanvasInteraction();
        bindKeyboardShortcuts();

        // Khôi phục URL nếu có query string
        if (window.location.search && UrlSync) {
            const parsed = UrlSync.parseUrlToState(window.location.search);
            if (parsed.isValid) {
                state.mode = parsed.mode;
                state.snap = parsed.snap;
                state.snapStep = parsed.snapStep;
                if (parsed.mode === 'free') {
                    state.vertices = parsed.vertices;
                } else {
                    state.activePreset = parsed.activePreset;
                    state.params = parsed.params;
                    state.vertices = parsed.vertices;
                }
                syncControlsWithState();
            }
        }

        await loadLabMeta();
        renderScene();
        updateAllPanels();

        const urlParams = new URLSearchParams(window.location.search);
        const tabParam = urlParams.get('tab');
        if (tabParam) {
            const tabMap = {
                'measurements': 'tabBtnMeasurements',
                'formulas': 'tabBtnFormulas',
                'classify': 'tabBtnClassify'
            };
            const btnId = tabMap[tabParam.toLowerCase()];
            if (btnId) {
                const targetBtn = document.getElementById(btnId);
                if (targetBtn) targetBtn.click();
            }
        }
    }

    /**
     * Tải siêu dữ liệu hình học từ Neo4j
     */
    async function loadLabMeta() {
        const loadingText = document.getElementById('labPresetLoadingText');
        const scrollContainer = document.getElementById('labPresetScroll');
        const errorContainer = document.getElementById('labPresetErrorContainer');

        if (loadingText) loadingText.style.display = 'inline';
        if (errorContainer) errorContainer.style.display = 'none';

        try {
            const res = await fetch('/api/lab/meta');
            if (!res.ok) throw new Error(`HTTP ${res.status}`);
            const data = await res.json();
            state.meta = data;

            if (loadingText) loadingText.style.display = 'none';
            renderPresetButtons(data.shapes || []);
        } catch (err) {
            console.error('Lỗi nạp /api/lab/meta:', err);
            if (loadingText) loadingText.style.display = 'none';
            if (scrollContainer) scrollContainer.innerHTML = '';

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
                if (btnRetry) btnRetry.addEventListener('click', loadLabMeta);
            }
        }
    }

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
                applyPreset(s.slug);
            });

            container.appendChild(btn);
        });
    }

    function applyPreset(slug) {
        if (!Presets) return;
        pushHistory();
        state.activePreset = slug;
        const p = Presets.getPreset(slug);
        state.params = { ...p.params };
        state.vertices = p.buildVertices ? p.buildVertices(p.params) : [...p.defaultVertices];

        document.querySelectorAll('.lab-preset-btn').forEach(btn => {
            const isMatch = btn.getAttribute('data-slug') === slug;
            btn.classList.toggle('active', isMatch);
            btn.setAttribute('aria-selected', isMatch ? 'true' : 'false');
        });

        renderScene();
        updateAllPanels();
        syncUrl();

        const alertMsg = document.getElementById('labAlertMessage');
        if (alertMsg) {
            alertMsg.textContent = `Đã vẽ hình mẫu: ${p.name}. Kéo các đỉnh hoặc thay đổi số đo để quan sát.`;
        }
    }

    function mathToSvg(x, y) {
        return {
            x: x * 24,
            y: -y * 24
        };
    }

    function svgToMath(px, py) {
        return {
            x: (px - state.pan.x) / (24 * state.zoom),
            y: (state.pan.y - py) / (24 * state.zoom)
        };
    }

    function applySnap(val) {
        if (!state.snap) {
            return Math.round(val * 100) / 100;
        }
        return Math.round(val);
    }

    /**
     * Vẽ toàn bộ hình học và các lớp lên SVG
     */
    function renderScene() {
        if (!Geometry) return;
        const [A, B, C, D] = state.vertices;
        const svgA = mathToSvg(A.x, A.y);
        const svgB = mathToSvg(B.x, B.y);
        const svgC = mathToSvg(C.x, C.y);
        const svgD = mathToSvg(D.x, D.y);

        // 1. Polygon diện tích
        const polyFill = document.getElementById('labPolyFill');
        if (polyFill) {
            polyFill.setAttribute('points', `${svgA.x},${svgA.y} ${svgB.x},${svgB.y} ${svgC.x},${svgC.y} ${svgD.x},${svgD.y}`);
        }

        // 2. Lớp Cạnh
        const edgesGroup = document.getElementById('labEdgesGroup');
        if (edgesGroup) {
            edgesGroup.innerHTML = '';
            const path = document.createElementNS('http://www.w3.org/2000/svg', 'path');
            path.setAttribute('d', `M ${svgA.x} ${svgA.y} L ${svgB.x} ${svgB.y} L ${svgC.x} ${svgC.y} L ${svgD.x} ${svgD.y} Z`);
            path.setAttribute('fill', 'none');
            path.setAttribute('stroke', '#1F3A93');
            path.setAttribute('stroke-width', '2.5');
            path.setAttribute('stroke-linejoin', 'round');
            edgesGroup.appendChild(path);

            if (state.layers.sides) {
                renderSideMeasurements(edgesGroup, [A, B, C, D], [svgA, svgB, svgC, svgD]);
            }
        }

        // 2.5 Lớp Trục đối xứng
        const symGroup = document.getElementById('labSymmetryGroup');
        if (symGroup) {
            symGroup.innerHTML = '';
            if (state.layers.axessym) {
                renderSymmetryAxes(symGroup, [A, B, C, D], [svgA, svgB, svgC, svgD]);
            }
        }

        // 3. Lớp Đường chéo
        const diagsGroup = document.getElementById('labDiagonalsGroup');
        if (diagsGroup) {
            diagsGroup.innerHTML = '';
            if (state.layers.diagonals) {
                const dAC = createLine(svgA, svgC, '#7A8B99', '1.5', '4,4');
                diagsGroup.appendChild(dAC);
                const dBD = createLine(svgB, svgD, '#7A8B99', '1.5', '4,4');
                diagsGroup.appendChild(dBD);

                const inter = Geometry.segmentsIntersection(A, C, B, D);
                if (inter) {
                    const svgO = mathToSvg(inter.x, inter.y);
                    const circleO = document.createElementNS('http://www.w3.org/2000/svg', 'circle');
                    circleO.setAttribute('cx', svgO.x);
                    circleO.setAttribute('cy', svgO.y);
                    circleO.setAttribute('r', '3.5');
                    circleO.setAttribute('fill', '#D64550');
                    diagsGroup.appendChild(circleO);

                    addSvgText(diagsGroup, svgO.x + 6, svgO.y - 6, 'O', '#D64550', '13px', 'start', 'bold');
                }
            }
        }

        // 4. Lớp Góc
        const anglesGroup = document.getElementById('labMeasurementsGroup');
        if (anglesGroup) {
            anglesGroup.innerHTML = '';
            if (state.layers.angles) {
                renderAngles(anglesGroup, [A, B, C, D], [svgA, svgB, svgC, svgD]);
            }
        }

        // 5. Lớp Ký hiệu hình học
        const marksGroup = document.getElementById('labMarksGroup');
        if (marksGroup) {
            marksGroup.innerHTML = '';
            if (state.layers.marks) {
                renderGeometricMarks(marksGroup, [A, B, C, D], [svgA, svgB, svgC, svgD]);
            }
        }

        // 6. Lớp 4 đỉnh kéo thả
        const verticesGroup = document.getElementById('labVerticesGroup');
        if (verticesGroup) {
            verticesGroup.innerHTML = '';
            const preset = Presets?.getPreset(state.activePreset);
            const handles = preset?.handles || ['A', 'B', 'C', 'D'];

            [svgA, svgB, svgC, svgD].forEach((svgP, idx) => {
                const mathP = state.vertices[idx];
                const vName = VERTEX_NAMES[idx];
                const isHandle = state.mode === 'free' || handles.includes(vName);

                const g = document.createElementNS('http://www.w3.org/2000/svg', 'g');
                g.setAttribute('class', `lab-vertex ${isHandle ? 'is-handle' : 'is-fixed'}`);
                g.setAttribute('data-index', idx);
                g.setAttribute('tabindex', isHandle ? '0' : '-1');
                g.setAttribute('role', 'slider');
                g.setAttribute('aria-label', `Đỉnh ${vName}: (${mathP.x}; ${mathP.y})`);
                g.style.cursor = isHandle ? 'grab' : 'not-allowed';
                if (!isHandle) {
                    g.style.opacity = '0.55';
                    g.setAttribute('title', "Đỉnh này đi theo hình mẫu. Bấm 'Mở khóa để kéo tự do' để kéo.");
                }

                // Vùng bấm vô hình >= 44px
                const hitCircle = document.createElementNS('http://www.w3.org/2000/svg', 'circle');
                hitCircle.setAttribute('cx', svgP.x);
                hitCircle.setAttribute('cy', svgP.y);
                hitCircle.setAttribute('r', '22');
                hitCircle.setAttribute('fill', 'transparent');
                hitCircle.setAttribute('pointer-events', 'all');
                g.appendChild(hitCircle);

                // Chấm tròn đỉnh
                const dotCircle = document.createElementNS('http://www.w3.org/2000/svg', 'circle');
                dotCircle.setAttribute('cx', svgP.x);
                dotCircle.setAttribute('cy', svgP.y);
                dotCircle.setAttribute('r', isHandle ? '6.5' : '5');
                dotCircle.setAttribute('fill', isHandle && state.mode === 'param' ? '#FFE66D' : '#1F3A93');
                dotCircle.setAttribute('stroke', isHandle && state.mode === 'param' ? '#1F3A93' : '#FFFFFF');
                dotCircle.setAttribute('stroke-width', '2');
                g.appendChild(dotCircle);

                // Nhãn chữ cái A, B, C, D
                const offset = getLabelOffset(idx);
                addSvgText(g, svgP.x + offset.x, svgP.y + offset.y, vName, '#1F3A93', '15px', 'middle', 'bold');

                verticesGroup.appendChild(g);
            });
        }

        updateClassification();
    }

    function getLabelOffset(idx) {
        switch (idx) {
            case 0: return { x: -14, y: 14 };
            case 1: return { x: 14, y: 14 };
            case 2: return { x: 14, y: -12 };
            case 3: return { x: -14, y: -12 };
            default: return { x: 0, y: -12 };
        }
    }

    function renderSideMeasurements(parent, mathPts, svgPts) {
        for (let i = 0; i < 4; i++) {
            const p1 = mathPts[i];
            const p2 = mathPts[(i + 1) % 4];
            const svgP1 = svgPts[i];
            const svgP2 = svgPts[(i + 1) % 4];

            const len = Geometry.distance(p1, p2);
            const midX = (svgP1.x + svgP2.x) / 2;
            const midY = (svgP1.y + svgP2.y) / 2;

            const dx = svgP2.x - svgP1.x;
            const dy = svgP2.y - svgP1.y;
            const dist = Math.hypot(dx, dy) || 1;
            const offX = -dy / dist * 12;
            const offY = dx / dist * 12;

            const t = addSvgText(parent, midX + offX, midY + offY, `${Geometry.formatNumberVi(len)} cm`, '#3B3F46', '11.5px', 'middle');
            t.setAttribute('paint-order', 'stroke');
            t.setAttribute('stroke', '#FFFFFF');
            t.setAttribute('stroke-width', '3px');
        }
    }

    function renderAngles(parent, mathPts, svgPts) {
        const angles = [
            Geometry.computeInteriorAngle(mathPts[3], mathPts[0], mathPts[1]),
            Geometry.computeInteriorAngle(mathPts[0], mathPts[1], mathPts[2]),
            Geometry.computeInteriorAngle(mathPts[1], mathPts[2], mathPts[3]),
            Geometry.computeInteriorAngle(mathPts[2], mathPts[3], mathPts[0])
        ];

        for (let i = 0; i < 4; i++) {
            const svgP = svgPts[i];
            const angVal = angles[i];
            const angStr = `${Geometry.formatNumberVi(angVal)}°`;

            const off = getLabelOffset(i);
            const t = addSvgText(parent, svgP.x + off.x * 1.8, svgP.y + off.y * 1.5, angStr, '#D64550', '11px', 'middle', '600');
            t.setAttribute('paint-order', 'stroke');
            t.setAttribute('stroke', '#FFFFFF');
            t.setAttribute('stroke-width', '3px');
        }
    }

    function renderGeometricMarks(parent, mathPts, svgPts) {
        const [A, B, C, D] = mathPts;
        const [svgA, svgB, svgC, svgD] = svgPts;

        // 1. Góc vuông
        const angles = [
            { idx: 0, val: Geometry.computeInteriorAngle(D, A, B), p: svgA, prev: svgD, next: svgB },
            { idx: 1, val: Geometry.computeInteriorAngle(A, B, C), p: svgB, prev: svgA, next: svgC },
            { idx: 2, val: Geometry.computeInteriorAngle(B, C, D), p: svgC, prev: svgB, next: svgD },
            { idx: 3, val: Geometry.computeInteriorAngle(C, D, A), p: svgD, prev: svgC, next: svgA }
        ];

        angles.forEach(a => {
            if (Math.abs(a.val - 90) <= Geometry.TOL_ANGLE) {
                drawRightAngleSquare(parent, a.p, a.prev, a.next);
            }
        });

        // 2. Song song
        const vAB = Geometry.vector(A, B);
        const vCD = Geometry.vector(C, D);
        if (Geometry.areParallel(vAB, vCD)) {
            drawParallelArrow(parent, svgA, svgB, 1);
            drawParallelArrow(parent, svgD, svgC, 1);
        }

        const vBC = Geometry.vector(B, C);
        const vDA = Geometry.vector(D, A);
        if (Geometry.areParallel(vBC, vDA)) {
            drawParallelArrow(parent, svgB, svgC, 2);
            drawParallelArrow(parent, svgA, svgD, 2);
        }
    }

    function drawRightAngleSquare(parent, p, p1, p2) {
        const v1 = Geometry.normalize({ x: p1.x - p.x, y: p1.y - p.y });
        const v2 = Geometry.normalize({ x: p2.x - p.x, y: p2.y - p.y });
        const s = 11;
        const pt1 = { x: p.x + v1.x * s, y: p.y + v1.y * s };
        const pt2 = { x: p.x + v1.x * s + v2.x * s, y: p.y + v1.y * s + v2.y * s };
        const pt3 = { x: p.x + v2.x * s, y: p.y + v2.y * s };

        const path = document.createElementNS('http://www.w3.org/2000/svg', 'path');
        path.setAttribute('d', `M ${pt1.x} ${pt1.y} L ${pt2.x} ${pt2.y} L ${pt3.x} ${pt3.y}`);
        path.setAttribute('fill', 'none');
        path.setAttribute('stroke', '#D64550');
        path.setAttribute('stroke-width', '1.5');
        parent.appendChild(path);
    }

    function drawParallelArrow(parent, p1, p2, count) {
        const midX = (p1.x + p2.x) / 2;
        const midY = (p1.y + p2.y) / 2;
        const u = Geometry.normalize({ x: p2.x - p1.x, y: p2.y - p1.y });
        const n = { x: -u.y, y: u.x };
        const size = 6;

        for (let i = 0; i < count; i++) {
            const offset = (i - (count - 1) / 2) * 8;
            const cx = midX + u.x * offset;
            const cy = midY + u.y * offset;

            const tip = { x: cx + u.x * size, y: cy + u.y * size };
            const left = { x: cx - u.x * size + n.x * size, y: cy - u.y * size + n.y * size };
            const right = { x: cx - u.x * size - n.x * size, y: cy - u.y * size - n.y * size };

            const path = document.createElementNS('http://www.w3.org/2000/svg', 'path');
            path.setAttribute('d', `M ${left.x} ${left.y} L ${tip.x} ${tip.y} L ${right.x} ${right.y}`);
            path.setAttribute('fill', 'none');
            path.setAttribute('stroke', '#1F3A93');
            path.setAttribute('stroke-width', '1.8');
            parent.appendChild(path);
        }
    }

    function createLine(p1, p2, stroke, width, dash) {
        const line = document.createElementNS('http://www.w3.org/2000/svg', 'line');
        line.setAttribute('x1', p1.x);
        line.setAttribute('y1', p1.y);
        line.setAttribute('x2', p2.x);
        line.setAttribute('y2', p2.y);
        line.setAttribute('stroke', stroke);
        line.setAttribute('stroke-width', width);
        if (dash) line.setAttribute('stroke-dasharray', dash);
        return line;
    }

    /**
     * Tương tác kéo thả chuột / chạm trên bảng vẽ SVG
     */
    function bindCanvasInteraction() {
        const svg = document.getElementById('labSvgCanvas');
        if (!svg) return;

        svg.addEventListener('pointerdown', (e) => {
            const vertexGroup = e.target.closest('.lab-vertex');
            if (!vertexGroup) return;

            const idx = parseInt(vertexGroup.getAttribute('data-index'), 10);
            if (isNaN(idx)) return;

            const vName = VERTEX_NAMES[idx];
            const preset = Presets?.getPreset(state.activePreset);
            const isHandle = state.mode === 'free' || (preset?.handles && preset.handles.includes(vName));

            if (!isHandle) {
                const alertMsg = document.getElementById('labAlertMessage');
                if (alertMsg) alertMsg.textContent = "Đỉnh này đi theo hình mẫu. Bấm 'Mở khóa để kéo tự do' để kéo.";
                return;
            }

            pushHistory();
            state.drag.active = true;
            state.drag.vertexIndex = idx;
            state.drag.pointerId = e.pointerId;
            svg.setPointerCapture(e.pointerId);

            const mathP = state.vertices[idx];
            state.drag.startX = mathP.x;
            state.drag.startY = mathP.y;

            vertexGroup.style.cursor = 'grabbing';
            e.preventDefault();
        });

        svg.addEventListener('pointermove', (e) => {
            if (!state.drag.active) return;

            const rect = svg.getBoundingClientRect();
            const svgX = (e.clientX - rect.left) * (720 / rect.width);
            const svgY = (e.clientY - rect.top) * (480 / rect.height);

            const rawMath = svgToMath(svgX, svgY);
            const snappedX = applySnap(rawMath.x);
            const snappedY = applySnap(rawMath.y);

            const clampedX = Math.max(-50, Math.min(50, snappedX));
            const clampedY = Math.max(-50, Math.min(50, snappedY));

            const idx = state.drag.vertexIndex;
            const vName = VERTEX_NAMES[idx];

            let testVertices = null;
            let newParams = null;

            if (state.mode === 'param') {
                const preset = Presets?.getPreset(state.activePreset);
                if (preset && preset.mapHandleToParams) {
                    newParams = preset.mapHandleToParams(vName, { x: clampedX, y: clampedY }, state.params);
                    testVertices = preset.buildVertices(newParams);
                }
            } else {
                testVertices = state.vertices.map((v, i) => i === idx ? { x: clampedX, y: clampedY } : { ...v });
            }

            if (!testVertices) return;

            const isValid = Geometry.isConvex(testVertices[0], testVertices[1], testVertices[2], testVertices[3]);

            const alertBanner = document.getElementById('labAlertBanner');
            const alertMsg = document.getElementById('labAlertMessage');
            const coordHint = document.getElementById('labCoordHint');

            if (isValid) {
                if (state.mode === 'param' && newParams) {
                    state.params = newParams;
                }
                state.vertices = testVertices;
                if (alertBanner) alertBanner.classList.remove('warning');
                if (alertMsg) alertMsg.textContent = `Đang di chuyển đỉnh ${vName}`;
                if (coordHint) coordHint.textContent = '';
                requestAnimationFrame(renderScene);
                updateAllPanels();
            } else {
                if (alertBanner) alertBanner.classList.add('warning');
                if (alertMsg) alertMsg.textContent = '⚠️ Hình sẽ bị lõm hoặc tự cắt. Hãy kéo đỉnh về phía khác.';
                const canvasCard = document.querySelector('.lab-canvas-card');
                if (canvasCard && !canvasCard.classList.contains('invalid-shake')) {
                    canvasCard.classList.add('invalid-shake');
                    setTimeout(() => canvasCard.classList.remove('invalid-shake'), 300);
                }
            }
        });

        const stopDrag = (e) => {
            if (!state.drag.active) return;
            const idx = state.drag.vertexIndex;
            const vertexGroup = svg.querySelector(`.lab-vertex[data-index="${idx}"]`);
            if (vertexGroup) vertexGroup.style.cursor = 'grab';

            try {
                if (state.drag.pointerId !== null) svg.releasePointerCapture(state.drag.pointerId);
            } catch (_) { }

            state.drag.active = false;
            state.drag.vertexIndex = -1;
            state.drag.pointerId = null;

            const alertBanner = document.getElementById('labAlertBanner');
            if (alertBanner) alertBanner.classList.remove('warning');
            const alertMsg = document.getElementById('labAlertMessage');
            if (alertMsg) alertMsg.textContent = 'Sẵn sàng. Kéo thả các đỉnh A, B, C, D để quan sát sự thay đổi.';
            const coordHint = document.getElementById('labCoordHint');
            if (coordHint) coordHint.textContent = '';

            requestAnimationFrame(renderScene);
            updateAllPanels();
            syncUrl();
        };

        svg.addEventListener('pointerup', stopDrag);
        svg.addEventListener('pointercancel', stopDrag);
    }

    /**
     * Bàn phím trợ năng
     */
    function bindKeyboardShortcuts() {
        document.addEventListener('keydown', (e) => {
            if ((e.ctrlKey || e.metaKey) && e.key.toLowerCase() === 'z' && !e.shiftKey) {
                e.preventDefault();
                undo();
                return;
            }
            if (((e.ctrlKey || e.metaKey) && e.key.toLowerCase() === 'y') ||
                ((e.ctrlKey || e.metaKey) && e.shiftKey && e.key.toLowerCase() === 'z')) {
                e.preventDefault();
                redo();
                return;
            }

            const activeElem = document.activeElement;
            if (activeElem && activeElem.classList.contains('lab-vertex')) {
                const idx = parseInt(activeElem.getAttribute('data-index'), 10);
                if (isNaN(idx)) return;

                const vName = VERTEX_NAMES[idx];
                const preset = Presets?.getPreset(state.activePreset);
                const isHandle = state.mode === 'free' || (preset?.handles && preset.handles.includes(vName));
                if (!isHandle) return;

                let dx = 0, dy = 0;
                const step = !state.snap ? 0.2 : (e.shiftKey ? 5 : 1);

                switch (e.key) {
                    case 'ArrowLeft': dx = -step; break;
                    case 'ArrowRight': dx = step; break;
                    case 'ArrowUp': dy = step; break;
                    case 'ArrowDown': dy = -step; break;
                    default: return;
                }

                e.preventDefault();
                pushHistory();
                const cur = state.vertices[idx];
                const newX = Math.round((cur.x + dx) * 100) / 100;
                const newY = Math.round((cur.y + dy) * 100) / 100;

                let testVertices = null;
                let newParams = null;

                if (state.mode === 'param') {
                    if (preset && preset.mapHandleToParams) {
                        newParams = preset.mapHandleToParams(vName, { x: newX, y: newY }, state.params);
                        testVertices = preset.buildVertices(newParams);
                    }
                } else {
                    testVertices = state.vertices.map((v, i) => i === idx ? { x: newX, y: newY } : { ...v });
                }

                if (testVertices && Geometry.isConvex(...testVertices)) {
                    if (state.mode === 'param' && newParams) state.params = newParams;
                    state.vertices = testVertices;
                    renderScene();
                    updateAllPanels();
                    syncUrl();
                }
            }
        });
    }

    function pushHistory() {
        state.history.undo.push({
            vertices: JSON.parse(JSON.stringify(state.vertices)),
            mode: state.mode,
            activePreset: state.activePreset,
            params: { ...state.params }
        });
        if (state.history.undo.length > 100) state.history.undo.shift();
        state.history.redo = [];
        updateHistoryButtons();
    }

    function undo() {
        if (state.history.undo.length === 0) return;
        state.history.redo.push({
            vertices: JSON.parse(JSON.stringify(state.vertices)),
            mode: state.mode,
            activePreset: state.activePreset,
            params: { ...state.params }
        });
        const snap = state.history.undo.pop();
        state.vertices = snap.vertices;
        state.mode = snap.mode;
        state.activePreset = snap.activePreset;
        state.params = snap.params;

        updateHistoryButtons();
        syncControlsWithState();
        renderScene();
        updateAllPanels();
        syncUrl();
    }

    function redo() {
        if (state.history.redo.length === 0) return;
        state.history.undo.push({
            vertices: JSON.parse(JSON.stringify(state.vertices)),
            mode: state.mode,
            activePreset: state.activePreset,
            params: { ...state.params }
        });
        const snap = state.history.redo.pop();
        state.vertices = snap.vertices;
        state.mode = snap.mode;
        state.activePreset = snap.activePreset;
        state.params = snap.params;

        updateHistoryButtons();
        syncControlsWithState();
        renderScene();
        updateAllPanels();
        syncUrl();
    }

    function updateHistoryButtons() {
        const btnUndo = document.getElementById('labBtnUndo');
        const btnRedo = document.getElementById('labBtnRedo');
        if (btnUndo) btnUndo.disabled = state.history.undo.length === 0;
        if (btnRedo) btnRedo.disabled = state.history.redo.length === 0;
    }

    function updateClassification() {
        if (!Classify) return;
        const [A, B, C, D] = state.vertices;
        const isaData = state.meta?.isa || Classify.DEFAULT_ISA;
        const res = Classify.classify(A, B, C, D, isaData);

        const statusText = document.getElementById('labStatusText');
        if (statusText) {
            statusText.textContent = res.statusText;
        }

        if (state.currentClassification && state.currentClassification.mostSpecific !== res.mostSpecific) {
            const diff = Classify.getConditionDiff(state.currentClassification.mostSpecific, res.mostSpecific, isaData);
            if (diff && !state.drag.active) {
                setAlertMessage(diff.message, true);
            }
        }
        state.currentClassification = res;
    }

    function setAlertMessage(msg, isSuccess = false) {
        const alertMsg = document.getElementById('labAlertMessage');
        const alertBanner = document.getElementById('labAlertBanner');
        if (alertMsg) alertMsg.textContent = msg;
        if (alertBanner) {
            alertBanner.className = isSuccess ? 'lab-alert-banner highlight-info' : 'lab-alert-banner';
        }
    }

    function updateAllPanels() {
        updateMeasurementsPanel();
        updateFormulasPanel();
        updateClassifyPanel();
    }

    /**
     * Cập nhật panel tab "Số đo" và ô nhập số hai chiều
     */
    function updateMeasurementsPanel() {
        const container = document.getElementById('labMeasurementsContent');
        if (!container || !Geometry) return;

        const [A, B, C, D] = state.vertices;
        const m = Geometry.computeMeasurements(A, B, C, D);

        let inputsHtml = '';
        if (state.mode === 'param') {
            inputsHtml = `
                <div class="lab-inputs-container">
                    <div class="d-flex align-items-center justify-content-between mb-2">
                        <span class="fw-bold" style="font-size: 0.95rem; color: var(--color-ink);">✎ Nhập tham số hình mẫu</span>
                        <button type="button" class="lab-unlock-btn" id="labBtnUnlockFree" title="Chuyển sang kéo thả 4 đỉnh độc lập">
                            🔓 Mở khóa kéo tự do
                        </button>
                    </div>
                    <div class="lab-input-grid">
                        ${Object.keys(state.params).map(k => `
                            <div class="lab-input-item">
                                <label for="paramInput_${k}">${getParamLabel(k)}</label>
                                <input type="text" inputmode="decimal" class="lab-number-input" id="paramInput_${k}" data-param="${k}" value="${state.params[k]}" />
                                <div class="lab-input-error-msg" id="paramErr_${k}"></div>
                            </div>
                        `).join('')}
                    </div>
                </div>
            `;
        } else {
            inputsHtml = `
                <div class="d-flex align-items-center justify-content-between mb-2">
                    <span class="small text-muted">Kéo thả các đỉnh tự do trên bảng vẽ</span>
                    <button type="button" class="lab-unlock-btn" id="labBtnLockPreset" title="Khóa về tham số hình mẫu">
                        🔒 Khóa về hình mẫu
                    </button>
                </div>
            `;
        }

        container.innerHTML = `
            <div style="font-size: 0.95rem;">
                <h5 style="font-size: 1.15rem; color: var(--color-ink); margin-bottom: 8px;">
                    📏 Độ dài các cạnh
                </h5>
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 6px; margin-bottom: 12px;">
                    <div>AB: <strong>${Geometry.formatNumberVi(m.sides.AB)} cm</strong></div>
                    <div>BC: <strong>${Geometry.formatNumberVi(m.sides.BC)} cm</strong></div>
                    <div>CD: <strong>${Geometry.formatNumberVi(m.sides.CD)} cm</strong></div>
                    <div>DA: <strong>${Geometry.formatNumberVi(m.sides.DA)} cm</strong></div>
                </div>

                <h5 style="font-size: 1.15rem; color: var(--color-ink); margin-bottom: 8px;">
                    📐 Các góc trong
                </h5>
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 6px; margin-bottom: 12px;">
                    <div>∠A: <strong>${Geometry.formatNumberVi(m.angles.A)}°</strong></div>
                    <div>∠B: <strong>${Geometry.formatNumberVi(m.angles.B)}°</strong></div>
                    <div>∠C: <strong>${Geometry.formatNumberVi(m.angles.C)}°</strong></div>
                    <div>∠D: <strong>${Geometry.formatNumberVi(m.angles.D)}°</strong></div>
                </div>
                <div class="small text-muted mb-2">Tổng 4 góc: <strong>${Geometry.formatNumberVi(m.angles.sum)}°</strong></div>

                <div style="background: #F4F8FD; border-left: 3px solid var(--color-ink); padding: 8px 10px; border-radius: 2px; margin-bottom: 10px;">
                    <div>Đường chéo AC: <strong>${Geometry.formatNumberVi(m.diagonals.AC)} cm</strong>, BD: <strong>${Geometry.formatNumberVi(m.diagonals.BD)} cm</strong></div>
                    <div>Chu vi (P): <strong style="color: var(--color-ink);">${Geometry.formatNumberVi(m.perimeter)} cm</strong></div>
                    <div>Diện tích (S): <strong style="color: var(--color-margin); font-size: 1.05rem;">${Geometry.formatNumberVi(m.area)} cm²</strong></div>
                </div>

                ${inputsHtml}
            </div>
        `;

        bindInputEvents();
    }

    function getParamLabel(key) {
        const labels = {
            a: 'Cạnh a (cm)',
            b: 'Cạnh b (cm)',
            h: 'Chiều cao h (cm)',
            s: 'Độ lệch s (cm)',
            dx: 'Độ dời dx (cm)',
            dy: 'Độ dời dy (cm)',
            d1: 'Đường chéo AC (cm)',
            d2: 'Đường chéo BD (cm)',
            p: 'Đoạn AO (cm)'
        };
        return labels[key] || `Tham số ${key}`;
    }

    function bindInputEvents() {
        const btnUnlock = document.getElementById('labBtnUnlockFree');
        if (btnUnlock) {
            btnUnlock.addEventListener('click', () => {
                state.mode = 'free';
                syncControlsWithState();
                renderScene();
                updateAllPanels();
                syncUrl();
            });
        }

        const btnLock = document.getElementById('labBtnLockPreset');
        if (btnLock) {
            btnLock.addEventListener('click', () => {
                state.mode = 'param';
                if (state.currentClassification?.mostSpecific) {
                    state.activePreset = state.currentClassification.mostSpecific;
                }
                syncControlsWithState();
                renderScene();
                updateAllPanels();
                syncUrl();
            });
        }

        // Ô nhập tham số hình mẫu (param mode)
        document.querySelectorAll('input[data-param]').forEach(input => {
            input.addEventListener('change', handleParamInputChange);
            input.addEventListener('keyup', (e) => {
                if (e.key === 'Enter') handleParamInputChange(e);
            });
        });
    }

    function handleParamInputChange(e) {
        const paramKey = e.target.getAttribute('data-param');
        const rawVal = e.target.value.replace(',', '.');
        const numVal = parseFloat(rawVal);
        const errElem = document.getElementById(`paramErr_${paramKey}`);

        if (isNaN(numVal) || numVal < 0.5 || numVal > 50) {
            e.target.classList.add('invalid');
            if (errElem) errElem.textContent = 'Giá trị từ 0.5 đến 50 cm';
            return;
        }

        const preset = Presets?.getPreset(state.activePreset);
        if (!preset) return;

        const newParams = { ...state.params, [paramKey]: numVal };
        const testVertices = preset.buildVertices(newParams);

        if (!Geometry.isConvex(...testVertices)) {
            e.target.classList.add('invalid');
            if (errElem) errElem.textContent = 'Hình sẽ bị lõm';
            return;
        }

        pushHistory();
        e.target.classList.remove('invalid');
        if (errElem) errElem.textContent = '';
        state.params = newParams;
        state.vertices = testVertices;
        renderScene();
        updateAllPanels();
        syncUrl();
    }

    /**
     * Cập nhật panel tab "Công thức" với KaTeX thay số & kiểm chứng chéo
     */
    function updateFormulasPanel() {
        const container = document.getElementById('labFormulasContent');
        if (!container || !Formulas) return;

        const allFormulas = state.meta?.formulas || [];
        const specificSlug = state.currentClassification?.mostSpecific || 'tu-giac';
        const ancestors = state.currentClassification?.ancestors || [];

        const directFormulas = allFormulas.filter(f => f.slug === specificSlug);
        const inheritedFormulas = allFormulas.filter(f => ancestors.includes(f.slug));

        // Khử trùng theo Formula.id
        const seenIds = new Set();
        const uniqueDirect = directFormulas.filter(f => {
            if (seenIds.has(f.id)) return false;
            seenIds.add(f.id);
            return true;
        });
        const uniqueInherited = inheritedFormulas.filter(f => {
            if (seenIds.has(f.id)) return false;
            seenIds.add(f.id);
            return true;
        });

        const [A, B, C, D] = state.vertices;

        function renderFormulaItem(f) {
            const computed = Formulas.computeFormula(f.id, A, B, C, D);
            let mathHtml = '';
            let checkBadgeHtml = '';

            if (computed) {
                const filledLatex = computed.latexFilled;
                mathHtml = window.katex ? window.katex.renderToString(filledLatex, { throwOnError: false }) : filledLatex;

                if (computed.isArea) {
                    if (computed.isMatchShoelace) {
                        checkBadgeHtml = `<span class="lab-formula-check-badge match">✓ Khớp diện tích thực tế (${Geometry.formatNumberVi(computed.shoelaceArea)} cm²)</span>`;
                    } else {
                        checkBadgeHtml = `<span class="lab-formula-check-badge mismatch">✗ Lệch diện tích thực tế</span>`;
                    }
                }
            } else {
                const origLatex = f.expression;
                mathHtml = window.katex ? window.katex.renderToString(origLatex, { throwOnError: false }) : origLatex;
                checkBadgeHtml = `<span class="small text-muted">Chưa có bộ tính thay số</span>`;
            }

            return `
                <div class="lab-formula-card">
                    <div class="lab-formula-title">
                        <span>${f.name}</span>
                        ${checkBadgeHtml}
                    </div>
                    <div class="lab-formula-math">${mathHtml}</div>
                    ${f.note ? `<div class="small text-muted">✎ ${f.note}</div>` : ''}
                </div>
            `;
        }

        container.innerHTML = `
            <div>
                <h5 style="font-size: 1.15rem; color: var(--color-ink); margin-bottom: 8px;">
                    ∑ Công thức trực tiếp (${Classify?.SHAPE_NAMES[specificSlug] || specificSlug})
                </h5>
                ${uniqueDirect.length > 0 ? uniqueDirect.map(renderFormulaItem).join('') : '<p class="text-muted small">Không có công thức riêng cho hình này.</p>'}

                ${uniqueInherited.length > 0 ? `
                    <details class="mt-3" open>
                        <summary style="font-size: 1.1rem; color: var(--color-ink); cursor: pointer; font-weight: 600; margin-bottom: 8px;">
                            🌿 Công thức kế thừa từ hình cha (${uniqueInherited.length} công thức)
                        </summary>
                        <div class="mt-2">
                            ${uniqueInherited.map(renderFormulaItem).join('')}
                        </div>
                    </details>
                ` : ''}
            </div>
        `;
    }

    /**
     * Cập nhật panel tab "Nhận dạng" và checklist tính chất đúng/sai
     */
    function updateClassifyPanel() {
        const container = document.getElementById('labClassifyContent');
        if (!container || !Geometry || !Classify) return;

        const [A, B, C, D] = state.vertices;
        const specificSlug = state.currentClassification?.mostSpecific || 'tu-giac';
        const curName = Classify.SHAPE_NAMES[specificSlug] || 'Tứ giác';
        const ancestors = state.currentClassification?.ancestors || [];
        const ancStr = ancestors.length > 0 ? ancestors.map(a => (Classify.SHAPE_NAMES[a] || a).toLowerCase()).join(', ') : '';

        // Tính toán các tính chất đúng/sai theo số đo thật
        const vAB = Geometry.vector(A, B);
        const vBC = Geometry.vector(B, C);
        const vCD = Geometry.vector(C, D);
        const vDA = Geometry.vector(D, A);

        const pAB_CD = Geometry.areParallel(vAB, vCD);
        const pBC_DA = Geometry.areParallel(vBC, vDA);
        const has1Parallel = pAB_CD || pBC_DA;
        const has2Parallel = pAB_CD && pBC_DA;

        const angA = Geometry.computeInteriorAngle(D, A, B);
        const angB = Geometry.computeInteriorAngle(A, B, C);
        const angC = Geometry.computeInteriorAngle(B, C, D);
        const angD = Geometry.computeInteriorAngle(C, D, A);
        const allRightAngles = Math.abs(angA - 90) <= Geometry.TOL_ANGLE &&
            Math.abs(angB - 90) <= Geometry.TOL_ANGLE &&
            Math.abs(angC - 90) <= Geometry.TOL_ANGLE &&
            Math.abs(angD - 90) <= Geometry.TOL_ANGLE;

        const dAB = Geometry.vectorLength(vAB);
        const dBC = Geometry.vectorLength(vBC);
        const dCD = Geometry.vectorLength(vCD);
        const dDA = Geometry.vectorLength(vDA);
        const fourSidesEqual = Geometry.approxEqual(dAB, dBC) && Geometry.approxEqual(dBC, dCD) && Geometry.approxEqual(dCD, dDA);

        const dAC = Geometry.distance(A, C);
        const dBD = Geometry.distance(B, D);
        const equalDiags = Geometry.approxEqual(dAC, dBD);
        const perpDiags = Geometry.arePerpendicular(Geometry.vector(A, C), Geometry.vector(B, D));

        container.innerHTML = `
            <div>
                <div class="lab-identity-banner">
                    <div class="lab-identity-name">${curName}</div>
                    ${ancStr ? `<p class="lab-ancestor-chain">Cũng là: <strong>${ancStr}</strong></p>` : ''}
                </div>

                <h5 style="font-size: 1.15rem; color: var(--color-ink); margin-bottom: 6px;">
                    ✓/✗ Kiểm tra tính chất hình học hiện tại
                </h5>
                <ul class="lab-property-checklist">
                    <li class="lab-property-item">
                        <span class="lab-prop-icon ${has1Parallel ? 'true' : 'false'}">${has1Parallel ? '✓' : '✗'}</span>
                        <span>Có ít nhất một cặp cạnh đối song song</span>
                    </li>
                    <li class="lab-property-item">
                        <span class="lab-prop-icon ${has2Parallel ? 'true' : 'false'}">${has2Parallel ? '✓' : '✗'}</span>
                        <span>Cả hai cặp cạnh đối song song</span>
                    </li>
                    <li class="lab-property-item">
                        <span class="lab-prop-icon ${allRightAngles ? 'true' : 'false'}">${allRightAngles ? '✓' : '✗'}</span>
                        <span>Có 4 góc vuông (90°)</span>
                    </li>
                    <li class="lab-property-item">
                        <span class="lab-prop-icon ${fourSidesEqual ? 'true' : 'false'}">${fourSidesEqual ? '✓' : '✗'}</span>
                        <span>Bốn cạnh bằng nhau</span>
                    </li>
                    <li class="lab-property-item">
                        <span class="lab-prop-icon ${equalDiags ? 'true' : 'false'}">${equalDiags ? '✓' : '✗'}</span>
                        <span>Hai đường chéo bằng nhau (AC = BD)</span>
                    </li>
                    <li class="lab-property-item">
                        <span class="lab-prop-icon ${perpDiags ? 'true' : 'false'}">${perpDiags ? '✓' : '✗'}</span>
                        <span>Hai đường chéo vuông góc với nhau (AC ⊥ BD)</span>
                    </li>
                </ul>

                ${renderConditionBoxHtml(specificSlug, curName)}
            </div>
        `;

        container.querySelectorAll('.lab-btn-apply-cond').forEach(btn => {
            btn.addEventListener('click', () => {
                const from = btn.getAttribute('data-from');
                const to = btn.getAttribute('data-to');
                applyCondition(from, to);
            });
        });
    }

    function renderConditionBoxHtml(specificSlug, curName) {
        if (!Transform?.TRANSFORM_RULES) return '';
        const availableRules = [];
        Object.keys(Transform.TRANSFORM_RULES).forEach(key => {
            const prefix = `${specificSlug}->`;
            if (key.startsWith(prefix)) {
                const childSlug = key.slice(prefix.length);
                let condText = '';
                if (state.meta?.isa) {
                    const rel = state.meta.isa.find(r => r.den === specificSlug && r.tu === childSlug);
                    if (rel) condText = rel.conditionShort || rel.condition;
                }
                if (!condText) {
                    const fallbackConds = {
                        'hinh-thang': 'Có ít nhất một cặp cạnh đối song song',
                        'hinh-dieu': 'Có hai cặp cạnh kề bằng nhau',
                        'hinh-thang-can': 'Hai góc kề một đáy bằng nhau (hoặc hai cạnh bên bằng nhau)',
                        'hinh-binh-hanh': 'Hai cặp cạnh đối song song',
                        'hinh-chu-nhat': 'Có một góc vuông (90°)',
                        'hinh-thoi': 'Bốn cạnh bằng nhau hoặc hai đường chéo vuông góc',
                        'hinh-vuong': specificSlug === 'hinh-chu-nhat' ? 'Hai cạnh kề bằng nhau' : 'Có một góc vuông (90°)'
                    };
                    condText = fallbackConds[childSlug] || 'Thỏa mãn thêm điều kiện hình học đặc thù';
                }
                availableRules.push({
                    from: specificSlug,
                    to: childSlug,
                    name: Classify?.SHAPE_NAMES[childSlug] || childSlug,
                    condition: condText
                });
            }
        });

        if (availableRules.length === 0) return '';

        return `
            <div class="lab-condition-box">
                <h5 style="font-size: 1.15rem; color: var(--color-ink); margin-bottom: 6px;">
                    ⚡ Chuyển hóa hình ("Áp dụng điều kiện")
                </h5>
                <p class="small text-muted mb-2">Thêm điều kiện hình học để biến ${curName} thành hình đặc biệt hơn:</p>
                <div>
                    ${availableRules.map(r => `
                        <div class="lab-condition-card">
                            <div class="lab-condition-info">
                                <div class="lab-condition-target-name">→ ${r.name}</div>
                                <div class="lab-condition-rule">Điều kiện: ${r.condition}</div>
                            </div>
                            <button type="button" class="lab-btn-apply-cond" data-from="${r.from}" data-to="${r.to}">
                                Thử điều kiện này
                            </button>
                        </div>
                    `).join('')}
                </div>
            </div>
        `;
    }

    /**
     * Thực hiện chuyển hóa hình theo quy tắc áp dụng điều kiện
     */
    function applyCondition(fromSlug, toSlug) {
        if (!Transform) return;
        const [A, B, C, D] = state.vertices;
        const newVerts = Transform.applyConditionTransform(fromSlug, toSlug, A, B, C, D);
        if (!newVerts) {
            alert('Không thể áp dụng điều kiện này với vị trí các đỉnh hiện tại (hình sẽ bị lõm hoặc tự cắt).');
            return;
        }

        pushHistory();
        state.vertices = newVerts;
        state.mode = 'free';
        state.activePreset = toSlug;
        syncControlsWithState();
        renderScene();
        updateAllPanels();
        syncUrl();

        const isaData = state.meta?.isa || Classify?.DEFAULT_ISA;
        const diff = Classify?.getConditionDiff(fromSlug, toSlug, isaData);
        const targetName = Classify?.SHAPE_NAMES[toSlug] || toSlug;
        if (diff) {
            setAlertMessage(diff.message, true);
        } else {
            setAlertMessage(`Đã thêm điều kiện để hình trở thành ${targetName}.`, true);
        }
    }

    /**
     * Vẽ lớp trục đối xứng thực tế của hình
     */
    function renderSymmetryAxes(parent, mathPts, svgPts) {
        if (!Geometry) return;
        const [A, B, C, D] = mathPts;
        const curSlug = state.currentClassification?.mostSpecific || state.activePreset;
        const isSquare = curSlug === 'hinh-vuong';
        const isRect = curSlug === 'hinh-chu-nhat';
        const isRhombus = curSlug === 'hinh-thoi';
        const isIsoscelesTrapezoid = curSlug === 'hinh-thang-can';
        const isKite = curSlug === 'hinh-dieu';

        const lines = [];

        if (isSquare) {
            lines.push({ p1: A, p2: C });
            lines.push({ p1: B, p2: D });
            lines.push({ p1: Geometry.midpoint(A, B), p2: Geometry.midpoint(C, D) });
            lines.push({ p1: Geometry.midpoint(B, C), p2: Geometry.midpoint(D, A) });
        } else if (isRect) {
            lines.push({ p1: Geometry.midpoint(A, B), p2: Geometry.midpoint(C, D) });
            lines.push({ p1: Geometry.midpoint(B, C), p2: Geometry.midpoint(D, A) });
        } else if (isRhombus) {
            lines.push({ p1: A, p2: C });
            lines.push({ p1: B, p2: D });
        } else if (isIsoscelesTrapezoid) {
            const vAB = Geometry.vector(A, B);
            const vCD = Geometry.vector(C, D);
            if (Geometry.areParallel(vAB, vCD)) {
                lines.push({ p1: Geometry.midpoint(A, B), p2: Geometry.midpoint(C, D) });
            } else {
                lines.push({ p1: Geometry.midpoint(B, C), p2: Geometry.midpoint(D, A) });
            }
        } else if (isKite) {
            const dAB = Geometry.distance(A, B);
            const dAD = Geometry.distance(A, D);
            if (Geometry.approxEqual(dAB, dAD)) {
                lines.push({ p1: A, p2: C });
            } else {
                lines.push({ p1: B, p2: D });
            }
        }

        lines.forEach((line, idx) => {
            const v = Geometry.vector(line.p1, line.p2);
            const u = Geometry.normalize(v);
            const ext1 = { x: line.p1.x - 1.5 * u.x, y: line.p1.y - 1.5 * u.y };
            const ext2 = { x: line.p2.x + 1.5 * u.x, y: line.p2.y + 1.5 * u.y };
            const svg1 = mathToSvg(ext1.x, ext1.y);
            const svg2 = mathToSvg(ext2.x, ext2.y);

            const svgLine = createLine(svg1, svg2, '#8E24AA', '1.6', '6,4');
            svgLine.setAttribute('class', 'lab-axis-sym');
            parent.appendChild(svgLine);

            if (idx === 0) {
                addSvgText(parent, svg2.x + 6, svg2.y + 3, 'Trục đ.xứng', '#8E24AA', '10px', 'start', 'normal');
            }
        });
    }



    /**
     * Tải hình vẽ SVG
     */
    function downloadSvg() {
        const svg = document.getElementById('labSvgCanvas');
        if (!svg) return;
        const clone = svg.cloneNode(true);
        clone.setAttribute('xmlns', 'http://www.w3.org/2000/svg');
        clone.setAttribute('width', '720');
        clone.setAttribute('height', '480');

        const styleElem = document.createElementNS('http://www.w3.org/2000/svg', 'style');
        styleElem.textContent = `
            text { font-family: 'Be Vietnam Pro', sans-serif; }
            .lab-axis-sym { stroke: #8E24AA; stroke-width: 1.6; stroke-dasharray: 6, 4; }
            .lab-axis-label { fill: #8E24AA; font-size: 10px; }
        `;
        let defs = clone.querySelector('defs');
        if (!defs) {
            defs = document.createElementNS('http://www.w3.org/2000/svg', 'defs');
            clone.insertBefore(defs, clone.firstChild);
        }
        defs.appendChild(styleElem);

        const serializer = new XMLSerializer();
        let source = serializer.serializeToString(clone);
        if (!source.match(/^<svg[^>]+xmlns="http\:\/\/www\.w3\.org\/2000\/svg"/)) {
            source = source.replace(/^<svg/, '<svg xmlns="http://www.w3.org/2000/svg"');
        }

        const blob = new Blob([source], { type: 'image/svg+xml;charset=utf-8' });
        const url = URL.createObjectURL(blob);
        const a = document.createElement('a');
        a.href = url;
        a.download = `xuong-ve-${state.activePreset}-${Date.now()}.svg`;
        document.body.appendChild(a);
        a.click();
        document.body.removeChild(a);
        URL.revokeObjectURL(url);
    }

    /**
     * Tải hình vẽ PNG nét cao
     */
    function downloadPng() {
        const svg = document.getElementById('labSvgCanvas');
        if (!svg) return;
        const clone = svg.cloneNode(true);
        clone.setAttribute('xmlns', 'http://www.w3.org/2000/svg');
        clone.setAttribute('width', '1440');
        clone.setAttribute('height', '960');

        const styleElem = document.createElementNS('http://www.w3.org/2000/svg', 'style');
        styleElem.textContent = `
            text { font-family: 'Be Vietnam Pro', sans-serif; }
            .lab-axis-sym { stroke: #8E24AA; stroke-width: 1.6; stroke-dasharray: 6, 4; }
            .lab-axis-label { fill: #8E24AA; font-size: 10px; }
        `;
        let defs = clone.querySelector('defs');
        if (!defs) {
            defs = document.createElementNS('http://www.w3.org/2000/svg', 'defs');
            clone.insertBefore(defs, clone.firstChild);
        }
        defs.appendChild(styleElem);

        const serializer = new XMLSerializer();
        const source = serializer.serializeToString(clone);
        const blob = new Blob([source], { type: 'image/svg+xml;charset=utf-8' });
        const url = URL.createObjectURL(blob);

        const img = new Image();
        img.onload = () => {
            const canvas = document.createElement('canvas');
            canvas.width = 1440;
            canvas.height = 960;
            const ctx = canvas.getContext('2d');
            ctx.fillStyle = '#FFFDF8';
            ctx.fillRect(0, 0, canvas.width, canvas.height);
            ctx.drawImage(img, 0, 0, canvas.width, canvas.height);
            URL.revokeObjectURL(url);

            canvas.toBlob((pngBlob) => {
                if (!pngBlob) return;
                const pngUrl = URL.createObjectURL(pngBlob);
                const a = document.createElement('a');
                a.href = pngUrl;
                a.download = `xuong-ve-${state.activePreset}-${Date.now()}.png`;
                document.body.appendChild(a);
                a.click();
                document.body.removeChild(a);
                URL.revokeObjectURL(pngUrl);
            }, 'image/png');
        };
        img.onerror = (err) => {
            console.error('Lỗi xuất PNG:', err);
            alert('Không thể tạo ảnh PNG. Bạn có thể sử dụng nút Tải SVG để thay thế.');
            URL.revokeObjectURL(url);
        };
        img.src = url;
    }

    function syncUrl() {
        if (!UrlSync) return;
        const query = UrlSync.serializeStateToUrl(state);
        window.history.replaceState(null, '', window.location.pathname + query);
    }

    function syncControlsWithState() {
        const snapCheck = document.getElementById('labSnapCheck');
        if (snapCheck) snapCheck.checked = state.snap;

        const modePresetBtn = document.getElementById('labModePresetBtn');
        const modeFreeBtn = document.getElementById('labModeFreeBtn');
        if (modePresetBtn && modeFreeBtn) {
            modePresetBtn.classList.toggle('active', state.mode === 'param');
            modeFreeBtn.classList.toggle('active', state.mode === 'free');
        }
    }

    function bindToolbarEvents() {
        const modePresetBtn = document.getElementById('labModePresetBtn');
        const modeFreeBtn = document.getElementById('labModeFreeBtn');
        if (modePresetBtn && modeFreeBtn) {
            modePresetBtn.addEventListener('click', () => {
                state.mode = 'param';
                modePresetBtn.classList.add('active');
                modeFreeBtn.classList.remove('active');
                renderScene();
                updateAllPanels();
                syncUrl();
            });
            modeFreeBtn.addEventListener('click', () => {
                state.mode = 'free';
                modeFreeBtn.classList.add('active');
                modePresetBtn.classList.remove('active');
                renderScene();
                updateAllPanels();
                syncUrl();
            });
        }

        const snapCheck = document.getElementById('labSnapCheck');
        if (snapCheck) {
            snapCheck.addEventListener('change', (e) => {
                state.snap = e.target.checked;
                syncUrl();
            });
        }

        ['Sides', 'Angles', 'Diagonals', 'Marks', 'AxesSym'].forEach(layer => {
            const chk = document.getElementById(`labLayer${layer}`);
            if (chk) {
                chk.addEventListener('change', (e) => {
                    state.layers[layer.toLowerCase()] = e.target.checked;
                    renderScene();
                });
            }
        });

        const btnUndo = document.getElementById('labBtnUndo');
        if (btnUndo) btnUndo.addEventListener('click', undo);

        const btnRedo = document.getElementById('labBtnRedo');
        if (btnRedo) btnRedo.addEventListener('click', redo);

        const btnReset = document.getElementById('labBtnReset');
        if (btnReset) {
            btnReset.addEventListener('click', () => {
                applyPreset(state.activePreset);
            });
        }

        const btnZoomIn = document.getElementById('labBtnZoomIn');
        const btnZoomOut = document.getElementById('labBtnZoomOut');
        const btnZoomFit = document.getElementById('labBtnZoomFit');
        if (btnZoomIn) {
            btnZoomIn.addEventListener('click', () => {
                state.zoom = Math.min(2.0, state.zoom + 0.1);
                applyTransform();
                renderScene();
            });
        }
        if (btnZoomOut) {
            btnZoomOut.addEventListener('click', () => {
                state.zoom = Math.max(0.5, state.zoom - 0.1);
                applyTransform();
                renderScene();
            });
        }
        if (btnZoomFit) {
            btnZoomFit.addEventListener('click', () => {
                state.zoom = 1;
                state.pan = { x: 260, y: 280 };
                applyTransform();
                renderScene();
            });
        }
    }

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
                if (activePane) activePane.classList.add('active');

                // Render lại công thức/nhận dạng khi mở tab
                if (targetTab === 'tabFormulas') updateFormulasPanel();
                if (targetTab === 'tabClassify') updateClassifyPanel();
            });
        });
    }

    function initSvgAxes() {
        const axesGroup = document.getElementById('labAxesGroup');
        if (!axesGroup) return;
        axesGroup.innerHTML = '';
        applyTransform();
    }

    function addSvgText(parent, x, y, text, color, fontSize, textAnchor, fontWeight) {
        const t = document.createElementNS('http://www.w3.org/2000/svg', 'text');
        t.setAttribute('x', x);
        t.setAttribute('y', y);
        t.setAttribute('fill', color);
        t.setAttribute('font-size', fontSize);
        t.setAttribute('font-family', "'Be Vietnam Pro', sans-serif");
        t.setAttribute('text-anchor', textAnchor || 'start');
        if (fontWeight) t.setAttribute('font-weight', fontWeight);
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