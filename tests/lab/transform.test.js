const test = require('node:test');
const assert = require('node:assert/strict');
const Presets = require('../../src/QuadWeb/wwwroot/js/lab/presets');
const Classify = require('../../src/QuadWeb/wwwroot/js/lab/classify');
const Transform = require('../../src/QuadWeb/wwwroot/js/lab/transform');

test('Transform: Kiểm tra 10 quy tắc áp dụng điều kiện theo Mục 8.5', () => {
    const rules = [
        { from: 'tu-giac', to: 'hinh-thang' },
        { from: 'tu-giac', to: 'hinh-dieu' },
        { from: 'hinh-thang', to: 'hinh-thang-can' },
        { from: 'hinh-thang', to: 'hinh-binh-hanh' },
        { from: 'hinh-binh-hanh', to: 'hinh-chu-nhat' },
        { from: 'hinh-thang-can', to: 'hinh-chu-nhat' },
        { from: 'hinh-binh-hanh', to: 'hinh-thoi' },
        { from: 'hinh-dieu', to: 'hinh-thoi' },
        { from: 'hinh-chu-nhat', to: 'hinh-vuong' },
        { from: 'hinh-thoi', to: 'hinh-vuong' }
    ];

    rules.forEach(({ from, to }) => {
        const parentPreset = Presets.getPreset(from);
        const [A, B, C, D] = parentPreset.defaultVertices;
        const newVertices = Transform.applyConditionTransform(from, to, A, B, C, D);

        assert.ok(newVertices, `Quy tắc ${from} -> ${to} phải trả về đỉnh hợp lệ`);
        assert.equal(newVertices.length, 4, `Quy tắc ${from} -> ${to} phải có 4 đỉnh`);

        const classRes = Classify.classify(...newVertices);
        assert.ok(classRes.isValidConvex, `Kết quả của ${from} -> ${to} phải là tứ giác lồi`);
        assert.ok(
            classRes.matchingSlugs.includes(to),
            `Kết quả nhận dạng của ${from} -> ${to} phải chứa ${to} (Thực tế: ${classRes.matchingSlugs.join(', ')})`
        );
    });
});
