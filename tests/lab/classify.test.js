const test = require('node:test');
const assert = require('node:assert/strict');
const Presets = require('../../src/QuadWeb/wwwroot/js/lab/presets');
const Classify = require('../../src/QuadWeb/wwwroot/js/lab/classify');

test('Classify: Kiểm tra 8 hình mẫu mặc định nhận dạng đúng chính nó theo Mục 8.1', () => {
    const expected = {
        'tu-giac': {
            mostSpecific: 'tu-giac',
            ancestors: []
        },
        'hinh-thang': {
            mostSpecific: 'hinh-thang',
            ancestors: ['tu-giac']
        },
        'hinh-thang-can': {
            mostSpecific: 'hinh-thang-can',
            ancestors: ['hinh-thang', 'tu-giac']
        },
        'hinh-binh-hanh': {
            mostSpecific: 'hinh-binh-hanh',
            ancestors: ['hinh-thang', 'tu-giac']
        },
        'hinh-chu-nhat': {
            mostSpecific: 'hinh-chu-nhat',
            ancestors: ['hinh-binh-hanh', 'hinh-thang-can', 'hinh-thang', 'tu-giac']
        },
        'hinh-thoi': {
            mostSpecific: 'hinh-thoi',
            ancestors: ['hinh-binh-hanh', 'hinh-dieu', 'hinh-thang', 'tu-giac']
        },
        'hinh-vuong': {
            mostSpecific: 'hinh-vuong',
            ancestors: ['hinh-chu-nhat', 'hinh-thoi', 'hinh-binh-hanh', 'hinh-thang-can', 'hinh-dieu', 'hinh-thang', 'tu-giac']
        },
        'hinh-dieu': {
            mostSpecific: 'hinh-dieu',
            ancestors: ['tu-giac']
        }
    };

    Object.keys(expected).forEach(slug => {
        const preset = Presets.getPreset(slug);
        const [A, B, C, D] = preset.defaultVertices;
        const res = Classify.classify(A, B, C, D);

        assert.equal(res.mostSpecific, expected[slug].mostSpecific, `Hình mẫu ${slug} phải có mostSpecific là ${expected[slug].mostSpecific}`);
        assert.ok(res.matchingSlugs.includes(slug), `Hình mẫu ${slug} phải có trong matchingSlugs`);

        // Kiểm tra tập tổ tiên
        expected[slug].ancestors.forEach(anc => {
            assert.ok(res.ancestors.includes(anc), `Tổ tiên của ${slug} phải chứa ${anc}`);
            assert.ok(res.matchingSlugs.includes(anc), `Tập thỏa mãn của ${slug} phải chứa ${anc}`);
        });
    });
});

test('Classify: Thông báo thêm/mất điều kiện theo Mục 8.6', () => {
    // 1. Hình chữ nhật -> Hình bình hành: mất góc vuông
    const diffUp = Classify.getConditionDiff('hinh-chu-nhat', 'hinh-binh-hanh');
    assert.ok(diffUp, 'Phải sinh diff khi từ hình chữ nhật sang hình bình hành');
    assert.equal(diffUp.type, 'generalized');
    assert.ok(diffUp.message.includes('Không còn'), 'Thông báo phải chứa "Không còn"');
    assert.ok(diffUp.message.includes('góc vuông'), 'Thông báo phải nhắc đến góc vuông');

    // 2. Hình chữ nhật -> Hình vuông: thêm 2 cạnh kề bằng nhau
    const diffDown = Classify.getConditionDiff('hinh-chu-nhat', 'hinh-vuong');
    assert.ok(diffDown, 'Phải sinh diff khi từ hình chữ nhật sang hình vuông');
    assert.equal(diffDown.type, 'specialized');
    assert.ok(diffDown.message.includes('Đã thêm điều kiện'), 'Thông báo phải chứa "Đã thêm điều kiện"');
    assert.ok(diffDown.message.toLowerCase().includes('cạnh kề bằng nhau'), 'Thông báo phải nhắc đến cạnh kề bằng nhau');

    // 3. Khác nhánh: Hình thang cân -> Hình bình hành
    const diffCross = Classify.getConditionDiff('hinh-thang-can', 'hinh-binh-hanh');
    assert.ok(diffCross, 'Phải sinh diff khi chuyển khác nhánh');
    assert.equal(diffCross.type, 'changed');
    assert.ok(diffCross.message.includes('Hình đổi từ Hình thang cân thành Hình bình hành'));
});
