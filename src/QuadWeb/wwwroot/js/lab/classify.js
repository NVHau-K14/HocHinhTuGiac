/**
 * NHẬN DẠNG VÀ PHÂN LOẠI HÌNH (CLASSIFY MODULE) - v2.4
 * Tự động phân loại 8 loại hình tứ giác dựa trên cây IS_A của Neo4j và tính toán hình học.
 */

(function (root, factory) {
    if (typeof module === 'object' && module.exports) {
        const Geometry = require('./geometry');
        module.exports = factory(Geometry);
    } else {
        root.QuadLab = root.QuadLab || {};
        root.QuadLab.Classify = factory(root.QuadLab.Geometry);
    }
}(typeof self !== 'undefined' ? self : this, function (Geometry) {
    'use strict';

    // Dữ liệu IS_A mặc định (dự phòng khi chưa nạp API hoặc chạy test độc lập)
    const DEFAULT_ISA = [
        { tu: 'hinh-thang', den: 'tu-giac', condition: 'Có một cặp cạnh đối song song', conditionShort: 'có 1 cặp cạnh đối song song' },
        { tu: 'hinh-thang-can', den: 'hinh-thang', condition: 'Có hai góc kề một đáy bằng nhau hoặc hai đường chéo bằng nhau', conditionShort: 'có 2 góc kề đáy bằng nhau' },
        { tu: 'hinh-binh-hanh', den: 'hinh-thang', condition: 'Cặp cạnh đối còn lại cũng song song', conditionShort: 'cặp cạnh còn lại cũng song song' },
        { tu: 'hinh-chu-nhat', den: 'hinh-thang-can', condition: 'Có một góc vuông', conditionShort: 'có 1 góc vuông' },
        { tu: 'hinh-chu-nhat', den: 'hinh-binh-hanh', condition: 'Có một góc vuông hoặc hai đường chéo bằng nhau', conditionShort: 'có 1 góc vuông' },
        { tu: 'hinh-thoi', den: 'hinh-binh-hanh', condition: 'Có hai cạnh kề bằng nhau hoặc hai đường chéo vuông góc', conditionShort: 'có 2 cạnh kề bằng nhau' },
        { tu: 'hinh-thoi', den: 'hinh-dieu', condition: 'Có bốn cạnh bằng nhau (cắt nhau tại trung điểm)', conditionShort: 'có 4 cạnh bằng nhau' },
        { tu: 'hinh-vuong', den: 'hinh-chu-nhat', condition: 'Có hai cạnh kề bằng nhau hoặc hai đường chéo vuông góc', conditionShort: 'có 2 cạnh kề bằng nhau' },
        { tu: 'hinh-vuong', den: 'hinh-thoi', condition: 'Có một góc vuông hoặc hai đường chéo bằng nhau', conditionShort: 'có 1 góc vuông' },
        { tu: 'hinh-dieu', den: 'tu-giac', condition: 'Có hai cặp cạnh kề bằng nhau', conditionShort: 'có 2 cặp cạnh kề bằng nhau' }
    ];

    const SHAPE_NAMES = {
        'tu-giac': 'Tứ giác',
        'hinh-thang': 'Hình thang',
        'hinh-thang-can': 'Hình thang cân',
        'hinh-binh-hanh': 'Hình bình hành',
        'hinh-chu-nhat': 'Hình chữ nhật',
        'hinh-thoi': 'Hình thoi',
        'hinh-vuong': 'Hình vuông',
        'hinh-dieu': 'Hình diều'
    };

    /**
     * Kiểm tra từng loại hình hình học
     */
    function checkShapeTypes(A, B, C, D) {
        const vAB = Geometry.vector(A, B);
        const vBC = Geometry.vector(B, C);
        const vCD = Geometry.vector(C, D);
        const vDA = Geometry.vector(D, A);

        const dAB = Geometry.vectorLength(vAB);
        const dBC = Geometry.vectorLength(vBC);
        const dCD = Geometry.vectorLength(vCD);
        const dDA = Geometry.vectorLength(vDA);

        const dAC = Geometry.distance(A, C);
        const dBD = Geometry.distance(B, D);

        const angA = Geometry.computeInteriorAngle(D, A, B);
        const angB = Geometry.computeInteriorAngle(A, B, C);
        const angC = Geometry.computeInteriorAngle(B, C, D);
        const angD = Geometry.computeInteriorAngle(C, D, A);

        const pAB_CD = Geometry.areParallel(vAB, vCD);
        const pBC_DA = Geometry.areParallel(vBC, vDA);

        const perpAC_BD = Geometry.arePerpendicular(Geometry.vector(A, C), Geometry.vector(B, D));

        const matches = new Set(['tu-giac']);

        // 1. Hình thang: có ít nhất 1 cặp cạnh đối song song
        const isTrapezoid = pAB_CD || pBC_DA;
        if (isTrapezoid) {
            matches.add('hinh-thang');

            // Hình thang cân:
            // Nếu AB // CD: hai góc kề đáy bằng nhau (angA == angB hoặc angC == angD) hoặc 2 đường chéo bằng nhau (AC == BD)
            // Nếu BC // DA: hai góc kề đáy bằng nhau (angB == angC hoặc angA == angD) hoặc 2 đường chéo bằng nhau (AC == BD)
            let isIsosceles = false;
            if (pAB_CD) {
                if (Math.abs(angA - angB) <= Geometry.TOL_ANGLE || Math.abs(angC - angD) <= Geometry.TOL_ANGLE) {
                    isIsosceles = true;
                }
            }
            if (pBC_DA) {
                if (Math.abs(angB - angC) <= Geometry.TOL_ANGLE || Math.abs(angA - angD) <= Geometry.TOL_ANGLE) {
                    isIsosceles = true;
                }
            }
            if (Geometry.approxEqual(dAC, dBD, Geometry.TOL_LENGTH)) {
                isIsosceles = true;
            }
            if (isIsosceles) {
                matches.add('hinh-thang-can');
            }
        }

        // 2. Hình bình hành: cả hai cặp cạnh đối song song
        const isParallelogram = pAB_CD && pBC_DA;
        if (isParallelogram) {
            matches.add('hinh-binh-hanh');
        }

        // 3. Hình chữ nhật: là hình bình hành có 1 góc vuông (hoặc hai đường chéo bằng nhau)
        if (isParallelogram) {
            const hasRightAngle = Math.abs(angA - 90) <= Geometry.TOL_ANGLE ||
                                  Math.abs(angB - 90) <= Geometry.TOL_ANGLE ||
                                  Math.abs(angC - 90) <= Geometry.TOL_ANGLE ||
                                  Math.abs(angD - 90) <= Geometry.TOL_ANGLE;
            const equalDiagonals = Geometry.approxEqual(dAC, dBD, Geometry.TOL_LENGTH);
            if (hasRightAngle || equalDiagonals) {
                matches.add('hinh-chu-nhat');
                matches.add('hinh-thang-can'); // Hình chữ nhật cũng là hình thang cân
            }
        }

        // 4. Hình diều: (AB = AD và CB = CD) hoặc (AB = BC và CD = DA)
        const isKite1 = Geometry.approxEqual(dAB, dDA, Geometry.TOL_LENGTH) && Geometry.approxEqual(dBC, dCD, Geometry.TOL_LENGTH);
        const isKite2 = Geometry.approxEqual(dAB, dBC, Geometry.TOL_LENGTH) && Geometry.approxEqual(dCD, dDA, Geometry.TOL_LENGTH);
        if (isKite1 || isKite2) {
            matches.add('hinh-dieu');
        }

        // 5. Hình thoi: 4 cạnh bằng nhau (hoặc hình bình hành có 2 cạnh kề bằng nhau, hoặc hình bình hành có 2 đường chéo vuông góc)
        const fourSidesEqual = Geometry.approxEqual(dAB, dBC, Geometry.TOL_LENGTH) &&
                               Geometry.approxEqual(dBC, dCD, Geometry.TOL_LENGTH) &&
                               Geometry.approxEqual(dCD, dDA, Geometry.TOL_LENGTH);
        const isRhombus = fourSidesEqual || (isParallelogram && (Geometry.approxEqual(dAB, dDA, Geometry.TOL_LENGTH) || perpAC_BD));
        if (isRhombus) {
            matches.add('hinh-thoi');
            matches.add('hinh-binh-hanh');
            matches.add('hinh-thang');
            matches.add('hinh-dieu'); // Hình thoi cũng là hình diều
        }

        // 6. Hình vuông: vừa là hình chữ nhật vừa là hình thoi
        if (matches.has('hinh-chu-nhat') && matches.has('hinh-thoi')) {
            matches.add('hinh-vuong');
        }

        return Array.from(matches);
    }

    /**
     * Tìm loại cụ thể nhất và danh sách tổ tiên theo cây IS_A
     */
    function classify(A, B, C, D, isaRelations = DEFAULT_ISA) {
        if (!Geometry.isConvex(A, B, C, D)) {
            return {
                isValidConvex: false,
                matchingSlugs: [],
                mostSpecific: null,
                ancestors: [],
                statusText: 'Hình không phải tứ giác lồi hoặc bị tự cắt'
            };
        }

        const matches = checkShapeTypes(A, B, C, D);
        const matchSet = new Set(matches);

        // Map quan hệ con -> cha
        const childOf = {}; // parent -> list of direct children
        isaRelations.forEach(r => {
            if (!childOf[r.den]) childOf[r.den] = [];
            childOf[r.den].push(r.tu);
        });

        // Loại cụ thể nhất: những hình trong matches mà KHÔNG CÓ hình con nào của nó cũng nằm trong matches
        const mostSpecificList = matches.filter(slug => {
            const children = childOf[slug] || [];
            return !children.some(ch => matchSet.has(ch));
        });

        const mostSpecific = mostSpecificList[0] || 'tu-giac';

        // Lấy tất cả tổ tiên của mostSpecific theo IS_A
        const ancestors = getAncestors(mostSpecific, isaRelations);

        // Tạo văn bản trạng thái
        let statusText = '';
        const curName = SHAPE_NAMES[mostSpecific] || mostSpecific;
        if (ancestors.length > 0) {
            const ancNames = ancestors.map(a => (SHAPE_NAMES[a] || a).toLowerCase()).join(', ');
            statusText = `${curName} (cũng là ${ancNames})`;
        } else {
            statusText = `${curName}`;
        }

        return {
            isValidConvex: true,
            matchingSlugs: matches,
            mostSpecific,
            mostSpecificList,
            ancestors,
            statusText
        };
    }

    /**
     * Lấy danh sách tổ tiên theo thứ tự từ gần đến xa
     */
    function getAncestors(slug, isaRelations) {
        const parentsMap = {};
        isaRelations.forEach(r => {
            if (!parentsMap[r.tu]) parentsMap[r.tu] = [];
            parentsMap[r.tu].push(r.den);
        });

        const queue = [slug];
        const visited = new Set();
        const ancestors = [];

        while (queue.length > 0) {
            const cur = queue.shift();
            const parents = parentsMap[cur] || [];
            for (const p of parents) {
                if (!visited.has(p)) {
                    visited.add(p);
                    ancestors.push(p);
                    queue.push(p);
                }
            }
        }
        return ancestors;
    }

    /**
     * So sánh thay đổi giữa 2 loại hình để tạo câu thông báo thêm/mất điều kiện (Mục 6.4)
     */
    function getConditionDiff(oldSlug, newSlug, isaRelations = DEFAULT_ISA) {
        if (!oldSlug || !newSlug || oldSlug === newSlug) return null;

        const oldName = SHAPE_NAMES[oldSlug] || oldSlug;
        const newName = SHAPE_NAMES[newSlug] || newSlug;

        // 1. Kiểm tra đi xuống (Đặc biệt hóa: oldSlug là cha của newSlug)
        const directDown = isaRelations.find(r => r.tu === newSlug && r.den === oldSlug);
        if (directDown) {
            const cond = directDown.conditionShort || directDown.condition || 'điều kiện hình học đặc biệt';
            return {
                type: 'specialized',
                message: `Đã thêm điều kiện: ${cond}. ${oldName} trở thành ${newName}.`,
                condition: cond
            };
        }

        // 2. Kiểm tra đi lên (Mất tính chất: newSlug là cha của oldSlug)
        const directUp = isaRelations.find(r => r.tu === oldSlug && r.den === newSlug);
        if (directUp) {
            const cond = directUp.conditionShort || directUp.condition || 'điều kiện hình học';
            return {
                type: 'generalized',
                message: `Không còn: ${cond}. ${oldName} trở thành ${newName}.`,
                condition: cond
            };
        }

        // 3. Khác nhánh (ví dụ hình thang cân -> hình bình hành)
        return {
            type: 'changed',
            message: `Hình đổi từ ${oldName} thành ${newName}.`,
            condition: null
        };
    }

    return {
        DEFAULT_ISA,
        SHAPE_NAMES,
        checkShapeTypes,
        classify,
        getAncestors,
        getConditionDiff
    };
}));
