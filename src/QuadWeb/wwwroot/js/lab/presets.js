/**
 * HÌNH MẪU VÀ THAM SỐ (PRESETS MODULE) - v2.4
 * Khai báo 8 hình mẫu hình học tứ giác, tham số, hàm sinh đỉnh và ánh xạ tay nắm.
 */

(function (root, factory) {
    if (typeof module === 'object' && module.exports) {
        module.exports = factory();
    } else {
        root.QuadLab = root.QuadLab || {};
        root.QuadLab.Presets = factory();
    }
}(typeof self !== 'undefined' ? self : this, function () {
    'use strict';

    const PRESETS = {
        'tu-giac': {
            slug: 'tu-giac',
            name: 'Tứ giác',
            defaultVertices: [
                { x: 0, y: 0 },
                { x: 7, y: 1 },
                { x: 6, y: 5 },
                { x: 1, y: 3 }
            ],
            params: {},
            handles: ['A', 'B', 'C', 'D'],
            buildVertices: function () {
                return [
                    { x: 0, y: 0 },
                    { x: 7, y: 1 },
                    { x: 6, y: 5 },
                    { x: 1, y: 3 }
                ];
            },
            mapHandleToParams: function (key, pos, curParams) {
                return curParams;
            }
        },

        'hinh-thang': {
            slug: 'hinh-thang',
            name: 'Hình thang',
            defaultVertices: [
                { x: 0, y: 0 },
                { x: 8, y: 0 },
                { x: 5, y: 3 },
                { x: 1, y: 3 }
            ],
            params: { a: 8, b: 4, h: 3, s: 1 },
            handles: ['B', 'C', 'D'],
            buildVertices: function (p) {
                const a = p.a !== undefined ? p.a : 8;
                const b = p.b !== undefined ? p.b : 4;
                const h = p.h !== undefined ? p.h : 3;
                const s = p.s !== undefined ? p.s : 1;
                return [
                    { x: 0, y: 0 },
                    { x: a, y: 0 },
                    { x: s + b, y: h },
                    { x: s, y: h }
                ];
            },
            mapHandleToParams: function (key, pos, cur) {
                const updated = { ...cur };
                if (key === 'B') {
                    updated.a = Math.max(2, Math.round(pos.x * 2) / 2);
                } else if (key === 'C') {
                    updated.h = Math.max(1, Math.round(pos.y * 2) / 2);
                    updated.b = Math.max(1, Math.round((pos.x - cur.s) * 2) / 2);
                } else if (key === 'D') {
                    updated.h = Math.max(1, Math.round(pos.y * 2) / 2);
                    updated.s = Math.round(pos.x * 2) / 2;
                }
                return updated;
            }
        },

        'hinh-thang-can': {
            slug: 'hinh-thang-can',
            name: 'Hình thang cân',
            defaultVertices: [
                { x: 0, y: 0 },
                { x: 8, y: 0 },
                { x: 6, y: 3 },
                { x: 2, y: 3 }
            ],
            params: { a: 8, b: 4, h: 3 },
            handles: ['B', 'C'],
            buildVertices: function (p) {
                const a = p.a !== undefined ? p.a : 8;
                const b = p.b !== undefined ? p.b : 4;
                const h = p.h !== undefined ? p.h : 3;
                const s = (a - b) / 2;
                return [
                    { x: 0, y: 0 },
                    { x: a, y: 0 },
                    { x: a - s, y: h },
                    { x: s, y: h }
                ];
            },
            mapHandleToParams: function (key, pos, cur) {
                const updated = { ...cur };
                if (key === 'B') {
                    updated.a = Math.max(cur.b + 1, Math.round(pos.x * 2) / 2);
                } else if (key === 'C') {
                    updated.h = Math.max(1, Math.round(pos.y * 2) / 2);
                    const halfB = Math.max(0.5, pos.x - cur.a / 2);
                    updated.b = Math.min(cur.a - 1, Math.max(1, Math.round(halfB * 2 * 2) / 2));
                }
                return updated;
            }
        },

        'hinh-binh-hanh': {
            slug: 'hinh-binh-hanh',
            name: 'Hình bình hành',
            defaultVertices: [
                { x: 0, y: 0 },
                { x: 6, y: 0 },
                { x: 8, y: 3 },
                { x: 2, y: 3 }
            ],
            params: { a: 6, dx: 2, dy: 3 },
            handles: ['B', 'D'],
            buildVertices: function (p) {
                const a = p.a !== undefined ? p.a : 6;
                const dx = p.dx !== undefined ? p.dx : 2;
                const dy = p.dy !== undefined ? p.dy : 3;
                return [
                    { x: 0, y: 0 },
                    { x: a, y: 0 },
                    { x: a + dx, y: dy },
                    { x: dx, y: dy }
                ];
            },
            mapHandleToParams: function (key, pos, cur) {
                const updated = { ...cur };
                if (key === 'B') {
                    updated.a = Math.max(2, Math.round(pos.x * 2) / 2);
                } else if (key === 'D') {
                    updated.dx = Math.round(pos.x * 2) / 2;
                    updated.dy = Math.max(1, Math.round(pos.y * 2) / 2);
                }
                return updated;
            }
        },

        'hinh-chu-nhat': {
            slug: 'hinh-chu-nhat',
            name: 'Hình chữ nhật',
            defaultVertices: [
                { x: 0, y: 0 },
                { x: 6, y: 0 },
                { x: 6, y: 4 },
                { x: 0, y: 4 }
            ],
            params: { a: 6, b: 4 },
            handles: ['B', 'C', 'D'],
            buildVertices: function (p) {
                const a = p.a !== undefined ? p.a : 6;
                const b = p.b !== undefined ? p.b : 4;
                return [
                    { x: 0, y: 0 },
                    { x: a, y: 0 },
                    { x: a, y: b },
                    { x: 0, y: b }
                ];
            },
            mapHandleToParams: function (key, pos, cur) {
                const updated = { ...cur };
                if (key === 'B') {
                    updated.a = Math.max(1, Math.round(pos.x * 2) / 2);
                } else if (key === 'D') {
                    updated.b = Math.max(1, Math.round(pos.y * 2) / 2);
                } else if (key === 'C') {
                    updated.a = Math.max(1, Math.round(pos.x * 2) / 2);
                    updated.b = Math.max(1, Math.round(pos.y * 2) / 2);
                }
                return updated;
            }
        },

        'hinh-thoi': {
            slug: 'hinh-thoi',
            name: 'Hình thoi',
            defaultVertices: [
                { x: 0, y: 0 },
                { x: 5, y: 0 },
                { x: 8, y: 4 },
                { x: 3, y: 4 }
            ],
            params: { a: 5, dx: 3, dy: 4 },
            handles: ['B', 'D'],
            buildVertices: function (p) {
                const a = p.a !== undefined ? p.a : 5;
                const dx = p.dx !== undefined ? p.dx : 3;
                const dy = p.dy !== undefined ? p.dy : 4;
                return [
                    { x: 0, y: 0 },
                    { x: a, y: 0 },
                    { x: a + dx, y: dy },
                    { x: dx, y: dy }
                ];
            },
            mapHandleToParams: function (key, pos, cur) {
                const updated = { ...cur };
                if (key === 'B') {
                    const newA = Math.max(2, Math.round(pos.x * 2) / 2);
                    const scale = newA / cur.a;
                    updated.a = newA;
                    updated.dx = Math.round(cur.dx * scale * 2) / 2;
                    updated.dy = Math.round(cur.dy * scale * 2) / 2;
                } else if (key === 'D') {
                    const newDx = Math.round(pos.x * 2) / 2;
                    const newDy = Math.max(1, Math.round(pos.y * 2) / 2);
                    const newA = Math.round(Math.hypot(newDx, newDy) * 2) / 2;
                    updated.a = newA;
                    updated.dx = newDx;
                    updated.dy = newDy;
                }
                return updated;
            }
        },

        'hinh-vuong': {
            slug: 'hinh-vuong',
            name: 'Hình vuông',
            defaultVertices: [
                { x: 0, y: 0 },
                { x: 5, y: 0 },
                { x: 5, y: 5 },
                { x: 0, y: 5 }
            ],
            params: { a: 5 },
            handles: ['B', 'C'],
            buildVertices: function (p) {
                const a = p.a !== undefined ? p.a : 5;
                return [
                    { x: 0, y: 0 },
                    { x: a, y: 0 },
                    { x: a, y: a },
                    { x: 0, y: a }
                ];
            },
            mapHandleToParams: function (key, pos, cur) {
                const updated = { ...cur };
                if (key === 'B') {
                    updated.a = Math.max(1, Math.round(pos.x * 2) / 2);
                } else if (key === 'C') {
                    const avg = (pos.x + pos.y) / 2;
                    updated.a = Math.max(1, Math.round(avg * 2) / 2);
                }
                return updated;
            }
        },

        'hinh-dieu': {
            slug: 'hinh-dieu',
            name: 'Hình diều',
            defaultVertices: [
                { x: 0, y: 0 },
                { x: 3, y: 2 },
                { x: 0, y: 8 },
                { x: -3, y: 2 }
            ],
            params: { d1: 8, d2: 6, p: 2 },
            handles: ['B', 'C'],
            buildVertices: function (param) {
                const d1 = param.d1 !== undefined ? param.d1 : 8;
                const d2 = param.d2 !== undefined ? param.d2 : 6;
                const p = param.p !== undefined ? param.p : 2;
                return [
                    { x: 0, y: 0 },
                    { x: d2 / 2, y: p },
                    { x: 0, y: d1 },
                    { x: -d2 / 2, y: p }
                ];
            },
            mapHandleToParams: function (key, pos, cur) {
                const updated = { ...cur };
                if (key === 'B') {
                    updated.d2 = Math.max(2, Math.round(Math.abs(pos.x) * 2 * 2) / 2);
                    updated.p = Math.min(cur.d1 - 1, Math.max(1, Math.round(pos.y * 2) / 2));
                } else if (key === 'C') {
                    updated.d1 = Math.max(cur.p + 1, Math.round(pos.y * 2) / 2);
                }
                return updated;
            }
        }
    };

    function getPreset(slug) {
        return PRESETS[slug] || PRESETS['tu-giac'];
    }

    function getAllPresets() {
        return Object.values(PRESETS);
    }

    return {
        PRESETS,
        getPreset,
        getAllPresets
    };
}));
