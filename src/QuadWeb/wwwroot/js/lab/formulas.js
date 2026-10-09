/**
 * BỘ TÍNH CÔNG THỨC HÌNH HỌC (FORMULAS MODULE) - v2.4
 * Tính toán thay số và kiểm chứng chéo diện tích từ tọa độ theo từng Formula.id.
 */

(function (root, factory) {
    if (typeof module === 'object' && module.exports) {
        const Geometry = require('./geometry');
        module.exports = factory(Geometry);
    } else {
        root.QuadLab = root.QuadLab || {};
        root.QuadLab.Formulas = factory(root.QuadLab.Geometry);
    }
}(typeof self !== 'undefined' ? self : this, function (Geometry) {
    'use strict';

    /**
     * Bảng ánh xạ hàm tính toán theo Formula.id
     */
    const COMPUTERS = {
        'F-TG-TONG-GOC': function (A, B, C, D, m) {
            const aA = Geometry.formatNumberVi(m.angles.A);
            const aB = Geometry.formatNumberVi(m.angles.B);
            const aC = Geometry.formatNumberVi(m.angles.C);
            const aD = Geometry.formatNumberVi(m.angles.D);
            return {
                id: 'F-TG-TONG-GOC',
                name: 'Tổng các góc trong tứ giác',
                latexFilled: `${aA}^\\circ + ${aB}^\\circ + ${aC}^\\circ + ${aD}^\\circ = 360^\\circ`,
                result: 360,
                unit: '°',
                isArea: false
            };
        },

        'F-HT-DIEN-TICH': function (A, B, C, D, m) {
            // Xác định cặp cạnh song song
            const vAB = Geometry.vector(A, B);
            const vCD = Geometry.vector(C, D);
            let a = m.sides.AB, b = m.sides.CD;
            let h = Geometry.pointToLineDistance(D, A, B);

            if (!Geometry.areParallel(vAB, vCD)) {
                // Thử cặp BC và DA
                a = m.sides.BC;
                b = m.sides.DA;
                h = Geometry.pointToLineDistance(A, B, C);
            }

            const area = ((a + b) * h) / 2;
            const strA = Geometry.formatNumberVi(a);
            const strB = Geometry.formatNumberVi(b);
            const strH = Geometry.formatNumberVi(h);
            const strRes = Geometry.formatNumberVi(area);

            return {
                id: 'F-HT-DIEN-TICH',
                name: 'Diện tích hình thang',
                latexFilled: `S = \\frac{(${strA} + ${strB}) \\cdot ${strH}}{2} = ${strRes} \\text{ cm}^2`,
                result: area,
                unit: 'cm²',
                isArea: true
            };
        },

        'F-HT-DUONG-TRUNG-BINH': function (A, B, C, D, m) {
            const a = m.sides.AB;
            const b = m.sides.CD;
            const res = (a + b) / 2;
            return {
                id: 'F-HT-DUONG-TRUNG-BINH',
                name: 'Độ dài đường trung bình hình thang',
                latexFilled: `m = \\frac{${Geometry.formatNumberVi(a)} + ${Geometry.formatNumberVi(b)}}{2} = ${Geometry.formatNumberVi(res)} \\text{ cm}`,
                result: res,
                unit: 'cm',
                isArea: false
            };
        },

        'F-HBH-DIEN-TICH': function (A, B, C, D, m) {
            const a = m.sides.AB;
            const h = Geometry.pointToLineDistance(D, A, B);
            const area = a * h;
            return {
                id: 'F-HBH-DIEN-TICH',
                name: 'Diện tích hình bình hành',
                latexFilled: `S = ${Geometry.formatNumberVi(a)} \\cdot ${Geometry.formatNumberVi(h)} = ${Geometry.formatNumberVi(area)} \\text{ cm}^2`,
                result: area,
                unit: 'cm²',
                isArea: true
            };
        },

        'F-HBH-CHU-VI': function (A, B, C, D, m) {
            const a = m.sides.AB;
            const b = m.sides.BC;
            const p = 2 * (a + b);
            return {
                id: 'F-HBH-CHU-VI',
                name: 'Chu vi hình bình hành',
                latexFilled: `P = 2 \\cdot (${Geometry.formatNumberVi(a)} + ${Geometry.formatNumberVi(b)}) = ${Geometry.formatNumberVi(p)} \\text{ cm}`,
                result: p,
                unit: 'cm',
                isArea: false
            };
        },

        'F-HCN-CHU-VI': function (A, B, C, D, m) {
            const a = m.sides.AB;
            const b = m.sides.BC;
            const p = 2 * (a + b);
            return {
                id: 'F-HCN-CHU-VI',
                name: 'Chu vi hình chữ nhật',
                latexFilled: `P = 2 \\cdot (${Geometry.formatNumberVi(a)} + ${Geometry.formatNumberVi(b)}) = ${Geometry.formatNumberVi(p)} \\text{ cm}`,
                result: p,
                unit: 'cm',
                isArea: false
            };
        },

        'F-HCN-DIEN-TICH': function (A, B, C, D, m) {
            const a = m.sides.AB;
            const b = m.sides.BC;
            const area = a * b;
            return {
                id: 'F-HCN-DIEN-TICH',
                name: 'Diện tích hình chữ nhật',
                latexFilled: `S = ${Geometry.formatNumberVi(a)} \\cdot ${Geometry.formatNumberVi(b)} = ${Geometry.formatNumberVi(area)} \\text{ cm}^2`,
                result: area,
                unit: 'cm²',
                isArea: true
            };
        },

        'F-HCN-CHEO': function (A, B, C, D, m) {
            const a = m.sides.AB;
            const b = m.sides.BC;
            const d = Math.hypot(a, b);
            return {
                id: 'F-HCN-CHEO',
                name: 'Đường chéo hình chữ nhật',
                latexFilled: `d = \\sqrt{${Geometry.formatNumberVi(a)}^2 + ${Geometry.formatNumberVi(b)}^2} \\approx ${Geometry.formatNumberVi(d)} \\text{ cm}`,
                result: d,
                unit: 'cm',
                isArea: false
            };
        },

        'F-S-HAI-CHEO': function (A, B, C, D, m) {
            const d1 = m.diagonals.AC;
            const d2 = m.diagonals.BD;
            const area = (d1 * d2) / 2;
            return {
                id: 'F-S-HAI-CHEO',
                name: 'Diện tích qua hai đường chéo vuông góc',
                latexFilled: `S = \\frac{${Geometry.formatNumberVi(d1)} \\cdot ${Geometry.formatNumberVi(d2)}}{2} = ${Geometry.formatNumberVi(area)} \\text{ cm}^2`,
                result: area,
                unit: 'cm²',
                isArea: true
            };
        },

        'F-THOI-CHU-VI': function (A, B, C, D, m) {
            const a = m.sides.AB;
            const p = 4 * a;
            return {
                id: 'F-THOI-CHU-VI',
                name: 'Chu vi hình thoi',
                latexFilled: `P = 4 \\cdot ${Geometry.formatNumberVi(a)} = ${Geometry.formatNumberVi(p)} \\text{ cm}`,
                result: p,
                unit: 'cm',
                isArea: false
            };
        },

        'F-VUONG-CHU-VI': function (A, B, C, D, m) {
            const a = m.sides.AB;
            const p = 4 * a;
            return {
                id: 'F-VUONG-CHU-VI',
                name: 'Chu vi hình vuông',
                latexFilled: `P = 4 \\cdot ${Geometry.formatNumberVi(a)} = ${Geometry.formatNumberVi(p)} \\text{ cm}`,
                result: p,
                unit: 'cm',
                isArea: false
            };
        },

        'F-VUONG-DIEN-TICH': function (A, B, C, D, m) {
            const a = m.sides.AB;
            const area = a * a;
            return {
                id: 'F-VUONG-DIEN-TICH',
                name: 'Diện tích hình vuông',
                latexFilled: `S = ${Geometry.formatNumberVi(a)}^2 = ${Geometry.formatNumberVi(area)} \\text{ cm}^2`,
                result: area,
                unit: 'cm²',
                isArea: true
            };
        },

        'F-VUONG-CHEO': function (A, B, C, D, m) {
            const a = m.sides.AB;
            const d = a * Math.SQRT2;
            return {
                id: 'F-VUONG-CHEO',
                name: 'Đường chéo hình vuông',
                latexFilled: `d = ${Geometry.formatNumberVi(a)}\\sqrt{2} \\approx ${Geometry.formatNumberVi(d)} \\text{ cm}`,
                result: d,
                unit: 'cm',
                isArea: false
            };
        }
    };

    /**
     * Tính toán công thức cho một ID và đối chiếu kiểm chứng chéo diện tích
     */
    function computeFormula(formulaId, A, B, C, D) {
        const computer = COMPUTERS[formulaId];
        if (!computer) {
            return null;
        }

        const m = Geometry.computeMeasurements(A, B, C, D);
        const res = computer(A, B, C, D, m);

        if (res && res.isArea) {
            const diff = Math.abs(res.result - m.area);
            res.isMatchShoelace = diff <= 0.02;
            res.shoelaceArea = m.area;
            res.diff = diff;
        }

        return res;
    }

    return {
        COMPUTERS,
        computeFormula
    };
}));
