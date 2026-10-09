/**
 * LÕI HÌNH HỌC (GEOMETRY MODULE) - v2.4
 * Các phép toán hình học thuần túy, độc lập DOM, chạy được trên cả Node.js và Trình duyệt.
 */

(function (root, factory) {
    if (typeof module === 'object' && module.exports) {
        module.exports = factory();
    } else {
        root.QuadLab = root.QuadLab || {};
        root.QuadLab.Geometry = factory();
    }
}(typeof self !== 'undefined' ? self : this, function () {
    'use strict';

    const TOL_LENGTH = 0.02; // cm
    const TOL_ANGLE = 0.5;   // độ (song song, vuông góc, góc bằng nhau)

    function distance(p1, p2) {
        return Math.hypot(p2.x - p1.x, p2.y - p1.y);
    }

    function vector(p1, p2) {
        return { x: p2.x - p1.x, y: p2.y - p1.y };
    }

    function dotProduct(v1, v2) {
        return v1.x * v2.x + v1.y * v2.y;
    }

    function crossProduct(v1, v2) {
        return v1.x * v2.y - v1.y * v2.x;
    }

    function vectorLength(v) {
        return Math.hypot(v.x, v.y);
    }

    function normalize(v) {
        const len = vectorLength(v);
        if (len === 0) return { x: 0, y: 0 };
        return { x: v.x / len, y: v.y / len };
    }

    function angleBetweenVectors(v1, v2) {
        const l1 = vectorLength(v1);
        const l2 = vectorLength(v2);
        if (l1 === 0 || l2 === 0) return 0;
        let cosTheta = dotProduct(v1, v2) / (l1 * l2);
        cosTheta = Math.max(-1, Math.min(1, cosTheta));
        return (Math.acos(cosTheta) * 180) / Math.PI;
    }

    function areParallel(v1, v2, tol = TOL_ANGLE) {
        const ang = angleBetweenVectors(v1, v2);
        return ang <= tol || Math.abs(180 - ang) <= tol;
    }

    function arePerpendicular(v1, v2, tol = TOL_ANGLE) {
        const ang = angleBetweenVectors(v1, v2);
        return Math.abs(ang - 90) <= tol;
    }

    function approxEqual(a, b, tol = TOL_LENGTH) {
        return Math.abs(a - b) <= tol;
    }

    function midpoint(p1, p2) {
        return { x: (p1.x + p2.x) / 2, y: (p1.y + p2.y) / 2 };
    }

    /**
     * Diện tích theo công thức dây giày (Shoelace formula)
     */
    function shoelaceArea(vertices) {
        const n = vertices.length;
        let sum = 0;
        for (let i = 0; i < n; i++) {
            const cur = vertices[i];
            const nxt = vertices[(i + 1) % n];
            sum += cur.x * nxt.y - nxt.x * cur.y;
        }
        return Math.abs(sum) / 2;
    }

    /**
     * Tìm giao điểm của hai đoạn thẳng (p1-p2) và (p3-p4)
     */
    function segmentsIntersection(p1, p2, p3, p4) {
        const x1 = p1.x, y1 = p1.y;
        const x2 = p2.x, y2 = p2.y;
        const x3 = p3.x, y3 = p3.y;
        const x4 = p4.x, y4 = p4.y;

        const denom = (y4 - y3) * (x2 - x1) - (x4 - x3) * (y2 - y1);
        if (Math.abs(denom) < 1e-9) return null; // song song hoặc trùng

        const ua = ((x4 - x3) * (y1 - y3) - (y4 - y3) * (x1 - x3)) / denom;
        const ub = ((x2 - x1) * (y1 - y3) - (y2 - y1) * (x1 - x3)) / denom;

        if (ua >= 0 && ua <= 1 && ub >= 0 && ub <= 1) {
            return {
                x: x1 + ua * (x2 - x1),
                y: y1 + ua * (y2 - y1),
                ua,
                ub
            };
        }
        return null;
    }

    /**
     * Tính góc trong tại đỉnh B của tứ giác lồi theo thứ tự đỉnh (A, B, C)
     */
    function computeInteriorAngle(prev, curr, next) {
        const v1 = vector(curr, prev);
        const v2 = vector(curr, next);
        return angleBetweenVectors(v1, v2);
    }

    /**
     * Khoảng cách từ điểm p đến đường thẳng nối a và b
     */
    function pointToLineDistance(p, a, b) {
        const vAB = vector(a, b);
        const lAB = vectorLength(vAB);
        if (lAB === 0) return distance(p, a);
        const vAP = vector(a, p);
        return Math.abs(crossProduct(vAB, vAP)) / lAB;
    }

    /**
     * Kiểm tra tứ giác lồi hợp lệ:
     * - Tích có hướng 4 góc liên tiếp cùng dấu (không lõm)
     * - Độ dài mỗi cạnh >= 0.5 cm
     * - Diện tích >= 1.0 cm²
     * - Hai đường chéo AC và BD cắt nhau chặt chẽ bên trong
     */
    function isConvex(A, B, C, D) {
        const pts = [A, B, C, D];
        
        // 1. Kiểm tra độ dài mỗi cạnh >= 0.5 cm
        for (let i = 0; i < 4; i++) {
            const d = distance(pts[i], pts[(i + 1) % 4]);
            if (d < 0.5) return false;
        }

        // 2. Kiểm tra diện tích >= 1.0 cm²
        const s = shoelaceArea(pts);
        if (s < 1.0) return false;

        // 3. Kiểm tra tích có hướng các cặp cạnh liên tiếp
        const signs = [];
        for (let i = 0; i < 4; i++) {
            const pPrev = pts[i];
            const pCur = pts[(i + 1) % 4];
            const pNext = pts[(i + 2) % 4];
            const v1 = vector(pPrev, pCur);
            const v2 = vector(pCur, pNext);
            const cp = crossProduct(v1, v2);
            if (Math.abs(cp) < 1e-4) return false; // 3 điểm thẳng hàng
            signs.push(cp > 0 ? 1 : -1);
        }

        const allPositive = signs.every(s => s === 1);
        const allNegative = signs.every(s => s === -1);
        if (!allPositive && !allNegative) return false; // có góc lõm

        // 4. Hai đường chéo AC và BD phải cắt nhau bên trong (không tự cắt, không lệch ngoài)
        const inter = segmentsIntersection(A, C, B, D);
        if (!inter) return false;
        if (inter.ua <= 0.005 || inter.ua >= 0.995 || inter.ub <= 0.005 || inter.ub >= 0.995) {
            return false;
        }

        return true;
    }

    /**
     * Định dạng số theo tiếng Việt (dấu phẩy thập phân, làm tròn 2 chữ số)
     */
    function formatNumberVi(num, decimals = 2) {
        if (num === null || num === undefined || isNaN(num)) return '0';
        const rounded = Math.round(num * Math.pow(10, decimals)) / Math.pow(10, decimals);
        if (Number.isInteger(rounded)) {
            return rounded.toString();
        }
        return rounded.toFixed(decimals).replace('.', ',');
    }

    /**
     * Tính toán toàn bộ các số đo từ 4 đỉnh A, B, C, D
     */
    function computeMeasurements(A, B, C, D) {
        const ab = distance(A, B);
        const bc = distance(B, C);
        const cd = distance(C, D);
        const da = distance(D, A);

        const ac = distance(A, C);
        const bd = distance(B, D);

        const angleA = computeInteriorAngle(D, A, B);
        const angleB = computeInteriorAngle(A, B, C);
        const angleC = computeInteriorAngle(B, C, D);
        const angleD = computeInteriorAngle(C, D, A);
        const angleSum = angleA + angleB + angleC + angleD;

        const perimeter = ab + bc + cd + da;
        const area = shoelaceArea([A, B, C, D]);
        const validConvex = isConvex(A, B, C, D);

        const interO = segmentsIntersection(A, C, B, D);
        const midAC = midpoint(A, C);
        const midBD = midpoint(B, D);

        return {
            sides: { AB: ab, BC: bc, CD: cd, DA: da },
            diagonals: { AC: ac, BD: bd },
            angles: { A: angleA, B: angleB, C: angleC, D: angleD, sum: angleSum },
            perimeter,
            area,
            isConvex: validConvex,
            intersectionO: interO ? { x: interO.x, y: interO.y } : null,
            midAC,
            midBD,
            areDiagonalsPerpendicular: arePerpendicular(vector(A, C), vector(B, D), TOL_ANGLE)
        };
    }

    return {
        TOL_LENGTH,
        TOL_ANGLE,
        distance,
        vector,
        dotProduct,
        crossProduct,
        vectorLength,
        normalize,
        angleBetweenVectors,
        areParallel,
        arePerpendicular,
        approxEqual,
        midpoint,
        shoelaceArea,
        segmentsIntersection,
        computeInteriorAngle,
        pointToLineDistance,
        isConvex,
        formatNumberVi,
        computeMeasurements
    };
}));
