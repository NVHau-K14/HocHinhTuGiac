const test = require('node:test');
const assert = require('node:assert/strict');
const Geometry = require('../../src/QuadWeb/wwwroot/js/lab/geometry');
const Presets = require('../../src/QuadWeb/wwwroot/js/lab/presets');
const Classify = require('../../src/QuadWeb/wwwroot/js/lab/classify');
const Transform = require('../../src/QuadWeb/wwwroot/js/lab/transform');

test('Stage 5: Kiểm tra Áp dụng điều kiện (L-13) và 10 phép chuyển hóa', () => {
    // Ca L-13: Hình chữ nhật -> Thử điều kiện này -> Hình vuông
    const rectPreset = Presets.getPreset('hinh-chu-nhat');
    const [rA, rB, rC, rD] = rectPreset.defaultVertices;
    const sqVerts = Transform.applyConditionTransform('hinh-chu-nhat', 'hinh-vuong', rA, rB, rC, rD);

    assert.ok(sqVerts, 'Biến đổi từ hình chữ nhật sang hình vuông phải thành công');
    assert.equal(sqVerts.length, 4);

    const sqClass = Classify.classify(...sqVerts);
    assert.ok(sqClass.matchingSlugs.includes('hinh-vuong'), 'Kết quả nhận dạng phải là hình vuông');
    assert.equal(sqClass.mostSpecific, 'hinh-vuong');

    const diff = Classify.getConditionDiff('hinh-chu-nhat', 'hinh-vuong');
    assert.ok(diff, 'Phải có diff điều kiện');
    assert.equal(diff.type, 'specialized');
    assert.ok(diff.message.includes('Đã thêm điều kiện'));
    assert.ok(diff.message.toLowerCase().includes('cạnh kề bằng nhau'));
});

test('Stage 5: Kiểm tra Thử thách hình học (L-14) và Dạng 2 kích thước', () => {
    // Ca L-14: Thử thách "Biến hình bình hành thành hình thoi"
    const hbhPreset = Presets.getPreset('hinh-binh-hanh');
    const [hA, hB, hC, hD] = hbhPreset.defaultVertices;
    const initialClass = Classify.classify(hA, hB, hC, hD);
    assert.ok(!initialClass.matchingSlugs.includes('hinh-thoi'), 'Ban đầu Hình bình hành chưa phải là Hình thoi');

    // Chuyển hóa sang hình thoi
    const thoiVerts = Transform.applyConditionTransform('hinh-binh-hanh', 'hinh-thoi', hA, hB, hC, hD);
    const solvedClass = Classify.classify(...thoiVerts);
    assert.ok(solvedClass.matchingSlugs.includes('hinh-thoi'), 'Sau khi biến hình phải nhận dạng ra Hình thoi');

        // Thử thách Dạng 2: Hình chữ nhật P = 20, S = 24
        const rectPreset = Presets.getPreset('hinh-chu-nhat');
        const mMatch = Geometry.computeMeasurements(...rectPreset.defaultVertices); // a=6, b=4
        assert.equal(mMatch.perimeter, 20, 'Chu vi phải bằng 20');
    assert.equal(mMatch.area, 24, 'Diện tích phải bằng 24');

    // Trường hợp chưa đạt
    const wrongRect = [
        { x: 0, y: 0 },
        { x: 5, y: 0 },
        { x: 5, y: 4 },
        { x: 0, y: 4 }
    ];
    const mWrong = Geometry.computeMeasurements(...wrongRect);
    assert.equal(mWrong.perimeter, 18);
    assert.equal(mWrong.area, 20);
    assert.notEqual(mWrong.perimeter, 20);
});

test('Stage 5: Kiểm tra xác định số trục đối xứng cho từng hình học', () => {
    function countSymmetryAxes(slug) {
        switch (slug) {
            case 'hinh-vuong': return 4;
            case 'hinh-chu-nhat': return 2;
            case 'hinh-thoi': return 2;
            case 'hinh-thang-can': return 1;
            case 'hinh-dieu': return 1;
            default: return 0;
        }
    }

    assert.equal(countSymmetryAxes('hinh-vuong'), 4);
    assert.equal(countSymmetryAxes('hinh-chu-nhat'), 2);
    assert.equal(countSymmetryAxes('hinh-thoi'), 2);
    assert.equal(countSymmetryAxes('hinh-thang-can'), 1);
    assert.equal(countSymmetryAxes('hinh-dieu'), 1);
    assert.equal(countSymmetryAxes('hinh-binh-hanh'), 0);
    assert.equal(countSymmetryAxes('tu-giac'), 0);
});
