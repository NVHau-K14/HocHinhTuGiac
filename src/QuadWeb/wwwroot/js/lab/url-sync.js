/**
 * ĐỒNG BỘ VÀ CHIA SẺ URL (URL-SYNC MODULE) - v2.4
 * Sinh liên kết và phân tích query string với kiểm tra chặt chẽ.
 */

(function (root, factory) {
    if (typeof module === 'object' && module.exports) {
        const Geometry = require('./geometry');
        const Presets = require('./presets');
        module.exports = factory(Geometry, Presets);
    } else {
        root.QuadLab = root.QuadLab || {};
        root.QuadLab.UrlSync = factory(root.QuadLab.Geometry, root.QuadLab.Presets);
    }
}(typeof self !== 'undefined' ? self : this, function (Geometry, Presets) {
    'use strict';

    /**
     * Tạo URL query string từ trạng thái hiện tại
     */
    function serializeStateToUrl(state) {
        const params = new URLSearchParams();
        if (state.mode === 'free') {
            params.set('mode', 'free');
            const ptsStr = state.vertices.map(v => `${v.x},${v.y}`).join(';');
            params.set('pts', ptsStr);
        } else {
            params.set('shape', state.activePreset || 'hinh-chu-nhat');
            if (state.params) {
                Object.keys(state.params).forEach(k => {
                    params.set(k, state.params[k]);
                });
            }
        }

        params.set('snap', state.snap ? '1' : '0');
        if (state.snapStep !== undefined) {
            params.set('step', state.snapStep.toString());
        }

        return '?' + params.toString();
    }

    /**
     * Phân tích URL query string và kiểm tra hợp lệ
     */
    function parseUrlToState(queryString) {
        const params = new URLSearchParams(queryString || '');
        const mode = params.get('mode') === 'free' ? 'free' : 'param';
        const snap = params.get('snap') !== '0';
        let snapStep = parseFloat(params.get('step') || '1');
        if (isNaN(snapStep)) snapStep = 1;

        if (mode === 'free') {
            const ptsStr = params.get('pts');
            if (!ptsStr) {
                return { isValid: false, message: 'Thiếu tham số tọa độ', fallback: 'hinh-chu-nhat' };
            }

            const rawPairs = ptsStr.split(';');
            if (rawPairs.length !== 4) {
                return { isValid: false, message: 'Cần đúng 4 đỉnh tứ giác', fallback: 'hinh-chu-nhat' };
            }

            const vertices = [];
            for (let pair of rawPairs) {
                const [sx, sy] = pair.split(',');
                const x = parseFloat(sx);
                const y = parseFloat(sy);
                if (isNaN(x) || isNaN(y) || Math.abs(x) > 50 || Math.abs(y) > 50) {
                    return { isValid: false, message: 'Tọa độ ngoài giới hạn hợp lệ', fallback: 'hinh-chu-nhat' };
                }
                vertices.push({ x, y });
            }

            if (!Geometry.isConvex(vertices[0], vertices[1], vertices[2], vertices[3])) {
                return { isValid: false, message: 'Tứ giác trong liên kết bị lõm hoặc tự cắt', fallback: 'hinh-chu-nhat' };
            }

            return {
                isValid: true,
                mode: 'free',
                vertices,
                snap,
                snapStep
            };
        } else {
            // Chế độ hình mẫu
            const shapeSlug = params.get('shape') || 'hinh-chu-nhat';
            const preset = Presets.getPreset(shapeSlug);
            const parsedParams = { ...preset.params };

            Object.keys(preset.params).forEach(k => {
                if (params.has(k)) {
                    const val = parseFloat(params.get(k));
                    if (!isNaN(val) && Math.abs(val) <= 50) {
                        parsedParams[k] = val;
                    }
                }
            });

            const vertices = preset.buildVertices(parsedParams);
            if (!Geometry.isConvex(vertices[0], vertices[1], vertices[2], vertices[3])) {
                return { isValid: false, message: 'Tham số hình mẫu không tạo ra tứ giác lồi', fallback: 'hinh-chu-nhat' };
            }

            return {
                isValid: true,
                mode: 'param',
                activePreset: preset.slug,
                params: parsedParams,
                vertices,
                snap,
                snapStep
            };
        }
    }

    return {
        serializeStateToUrl,
        parseUrlToState
    };
}));
