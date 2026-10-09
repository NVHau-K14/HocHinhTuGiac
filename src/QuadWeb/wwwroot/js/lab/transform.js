/**
 * ÁP DỤNG ĐIỀU KIỆN BIẾN HÌNH (TRANSFORM MODULE) - v2.4
 * Thực thi 10 quy tắc chuyển hóa hình học chuẩn SGK từ hình cha sang hình con.
 */

(function (root, factory) {
    if (typeof module === 'object' && module.exports) {
        const Geometry = require('./geometry');
        module.exports = factory(Geometry);
    } else {
        root.QuadLab = root.QuadLab || {};
        root.QuadLab.Transform = factory(root.QuadLab.Geometry);
    }
}(typeof self !== 'undefined' ? self : this, function (Geometry) {
    'use strict';

    /**
     * Vectơ pháp tuyến đơn vị hướng vào phía nửa mặt phẳng chứa điểm tham chiếu C
     */
    function normalUnit(v, refPoint, origin) {
        // v = (vx, vy), hai pháp tuyến là (-vy, vx) và (vy, -vx)
        const n1 = Geometry.normalize({ x: -v.y, y: v.x });
        const vRef = Geometry.vector(origin, refPoint);
        if (Geometry.dotProduct(n1, vRef) >= 0) {
            return n1;
        }
        return { x: -n1.x, y: -n1.y };
    }

    /**
     * Điểm đối xứng của P qua đường thẳng nối P1 và P2
     */
    function reflectPointAcrossLine(P, P1, P2) {
        const v = Geometry.vector(P1, P2);
        const lenSq = v.x * v.x + v.y * v.y;
        if (lenSq === 0) return { ...P };
        const vP1P = Geometry.vector(P1, P);
        const t = (vP1P.x * v.x + vP1P.y * v.y) / lenSq;
        const proj = { x: P1.x + t * v.x, y: P1.y + t * v.y };
        return {
            x: 2 * proj.x - P.x,
            y: 2 * proj.y - P.y
        };
    }

    function roundCoord(val) {
        return Math.round(val * 10000) / 10000;
    }

    const TRANSFORM_RULES = {
        // 1. Tứ giác → Hình thang: CD // AB (giữ A, B, C; D' = C - |CD|*u(AB))
        'tu-giac->hinh-thang': function (A, B, C, D) {
            const vAB = Geometry.vector(A, B);
            const uAB = Geometry.normalize(vAB);
            const lenCD = Geometry.distance(C, D);
            const newD = {
                x: roundCoord(C.x - lenCD * uAB.x),
                y: roundCoord(C.y - lenCD * uAB.y)
            };
            return [{ ...A }, { ...B }, { ...C }, newD];
        },

        // 2. Tứ giác → Hình diều: D' = đối xứng của B qua AC
        'tu-giac->hinh-dieu': function (A, B, C, D) {
            const newD = reflectPointAcrossLine(B, A, C);
            return [
                { ...A },
                { ...B },
                { ...C },
                { x: roundCoord(newD.x), y: roundCoord(newD.y) }
            ];
        },

        // 3. Hình thang → Hình thang cân: C, D đối xứng qua trung trực AB
        'hinh-thang->hinh-thang-can': function (A, B, C, D) {
            const midAB = Geometry.midpoint(A, B);
            const vAB = Geometry.vector(A, B);
            const nAB = normalUnit(vAB, C, A);

            const lenCD = Geometry.distance(C, D);
            const h = Geometry.pointToLineDistance(C, A, B);
            const topMid = { x: midAB.x + h * nAB.x, y: midAB.y + h * nAB.y };
            const uAB = Geometry.normalize(vAB);

            const newC = {
                x: roundCoord(topMid.x + (lenCD / 2) * uAB.x),
                y: roundCoord(topMid.y + (lenCD / 2) * uAB.y)
            };
            const newD = {
                x: roundCoord(topMid.x - (lenCD / 2) * uAB.x),
                y: roundCoord(topMid.y - (lenCD / 2) * uAB.y)
            };
            return [{ ...A }, { ...B }, newC, newD];
        },

        // 4. Hình thang → Hình bình hành: D' = A + (C - B)
        'hinh-thang->hinh-binh-hanh': function (A, B, C, D) {
            const newD = {
                x: roundCoord(A.x + (C.x - B.x)),
                y: roundCoord(A.y + (C.y - B.y))
            };
            return [{ ...A }, { ...B }, { ...C }, newD];
        },

        // 5. Hình bình hành → Hình chữ nhật: D' = A + |AD|*n(AB); C' = B + (D' - A)
        'hinh-binh-hanh->hinh-chu-nhat': function (A, B, C, D) {
            const vAB = Geometry.vector(A, B);
            const nAB = normalUnit(vAB, D, A);
            const lenAD = Geometry.distance(A, D);
            const newD = {
                x: roundCoord(A.x + lenAD * nAB.x),
                y: roundCoord(A.y + lenAD * nAB.y)
            };
            const newC = {
                x: roundCoord(B.x + (newD.x - A.x)),
                y: roundCoord(B.y + (newD.y - A.y))
            };
            return [{ ...A }, { ...B }, newC, newD];
        },

        // 6. Hình thang cân → Hình chữ nhật: D' = A + h*n(AB); C' = B + (D' - A)
        'hinh-thang-can->hinh-chu-nhat': function (A, B, C, D) {
            const vAB = Geometry.vector(A, B);
            const nAB = normalUnit(vAB, D, A);
            const h = Geometry.pointToLineDistance(D, A, B);
            const newD = {
                x: roundCoord(A.x + h * nAB.x),
                y: roundCoord(A.y + h * nAB.y)
            };
            const newC = {
                x: roundCoord(B.x + (newD.x - A.x)),
                y: roundCoord(B.y + (newD.y - A.y))
            };
            return [{ ...A }, { ...B }, newC, newD];
        },

        // 7. Hình bình hành → Hình thoi: D' = A + |AB|*u(AD); C' = B + (D' - A)
        'hinh-binh-hanh->hinh-thoi': function (A, B, C, D) {
            const vAD = Geometry.vector(A, D);
            const uAD = Geometry.normalize(vAD);
            const lenAB = Geometry.distance(A, B);
            const newD = {
                x: roundCoord(A.x + lenAB * uAD.x),
                y: roundCoord(A.y + lenAB * uAD.y)
            };
            const newC = {
                x: roundCoord(B.x + (newD.x - A.x)),
                y: roundCoord(B.y + (newD.y - A.y))
            };
            return [{ ...A }, { ...B }, newC, newD];
        },

        // 8. Hình diều → Hình thoi: B, D đối xứng qua AC tại trung điểm O của AC
        'hinh-dieu->hinh-thoi': function (A, B, C, D) {
            const midAC = Geometry.midpoint(A, C);
            const vAC = Geometry.vector(A, C);
            const nAC = normalUnit(vAC, B, A);
            const lenBD = Geometry.distance(B, D);
            const halfBD = lenBD / 2;

            const newB = {
                x: roundCoord(midAC.x + halfBD * nAC.x),
                y: roundCoord(midAC.y + halfBD * nAC.y)
            };
            const newD = {
                x: roundCoord(midAC.x - halfBD * nAC.x),
                y: roundCoord(midAC.y - halfBD * nAC.y)
            };
            return [{ ...A }, newB, { ...C }, newD];
        },

        // 9. Hình chữ nhật → Hình vuông: D' = A + |AB|*n(AB); C' = B + (D' - A)
        'hinh-chu-nhat->hinh-vuong': function (A, B, C, D) {
            const vAB = Geometry.vector(A, B);
            const nAB = normalUnit(vAB, D, A);
            const lenAB = Geometry.distance(A, B);
            const newD = {
                x: roundCoord(A.x + lenAB * nAB.x),
                y: roundCoord(A.y + lenAB * nAB.y)
            };
            const newC = {
                x: roundCoord(B.x + (newD.x - A.x)),
                y: roundCoord(B.y + (newD.y - A.y))
            };
            return [{ ...A }, { ...B }, newC, newD];
        },

        // 10. Hình thoi → Hình vuông: giữ O và AC, đặt BD = AC vuông góc tại O
        'hinh-thoi->hinh-vuong': function (A, B, C, D) {
            const midAC = Geometry.midpoint(A, C);
            const vAC = Geometry.vector(A, C);
            const nAC = normalUnit(vAC, B, A);
            const lenAC = Geometry.distance(A, C);
            const half = lenAC / 2;

            const newB = {
                x: roundCoord(midAC.x + half * nAC.x),
                y: roundCoord(midAC.y + half * nAC.y)
            };
            const newD = {
                x: roundCoord(midAC.x - half * nAC.x),
                y: roundCoord(midAC.y - half * nAC.y)
            };
            return [{ ...A }, newB, { ...C }, newD];
        }
    };


    /**
     * Thực hiện chuyển đổi nếu thỏa mãn điều kiện lồi
     */
    function applyConditionTransform(fromSlug, toSlug, A, B, C, D) {
        const key = `${fromSlug}->${toSlug}`;
        const rule = TRANSFORM_RULES[key];
        if (!rule) return null;

        const newVertices = rule(A, B, C, D);
        if (!newVertices || newVertices.length !== 4) return null;

        const [nA, nB, nC, nD] = newVertices;
        if (!Geometry.isConvex(nA, nB, nC, nD)) {
            return null; // Không tạo ra hình lồi hợp lệ
        }

        return newVertices;
    }

    return {
        TRANSFORM_RULES,
        applyConditionTransform
    };
}));
