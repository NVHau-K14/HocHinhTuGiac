const test = require('node:test');
const assert = require('node:assert/strict');
const Geometry = require('../../src/QuadWeb/wwwroot/js/lab/geometry');
const Presets = require('../../src/QuadWeb/wwwroot/js/lab/presets');

test('Geometry: Kiểm tra số đo 8 hình mẫu mặc định theo Mục 8.2', () => {
    // 1. Tứ giác: S = 21
    const pTG = Presets.getPreset('tu-giac').defaultVertices;
    const mTG = Geometry.computeMeasurements(...pTG);
    assert.equal(Math.round(mTG.area), 21, 'Diện tích tứ giác phải là 21');

    // 2. Hình thang: S = 18
    const pHT = Presets.getPreset('hinh-thang').defaultVertices;
    const mHT = Geometry.computeMeasurements(...pHT);
    assert.equal(Math.round(mHT.area), 18, 'Diện tích hình thang phải là 18');

    // 3. Hình thang cân: S = 18
    const pHTC = Presets.getPreset('hinh-thang-can').defaultVertices;
    const mHTC = Geometry.computeMeasurements(...pHTC);
    assert.equal(Math.round(mHTC.area), 18, 'Diện tích hình thang cân phải là 18');

    // 4. Hình bình hành: S = 18
    const pHBH = Presets.getPreset('hinh-binh-hanh').defaultVertices;
    const mHBH = Geometry.computeMeasurements(...pHBH);
    assert.equal(Math.round(mHBH.area), 18, 'Diện tích hình bình hành phải là 18');

    // 5. Hình chữ nhật: S = 24, P = 20, d ≈ 7.21
    const pHCN = Presets.getPreset('hinh-chu-nhat').defaultVertices;
    const mHCN = Geometry.computeMeasurements(...pHCN);
    assert.equal(Math.round(mHCN.area), 24, 'Diện tích hình chữ nhật phải là 24');
    assert.equal(Math.round(mHCN.perimeter), 20, 'Chu vi hình chữ nhật phải là 20');
    assert.ok(Math.abs(mHCN.diagonals.AC - 7.21) < 0.02, 'Đường chéo hình chữ nhật ≈ 7.21');

    // 6. Hình thoi: S = 20, P = 20
    const pThoi = Presets.getPreset('hinh-thoi').defaultVertices;
    const mThoi = Geometry.computeMeasurements(...pThoi);
    assert.equal(Math.round(mThoi.area), 20, 'Diện tích hình thoi phải là 20');
    assert.equal(Math.round(mThoi.perimeter), 20, 'Chu vi hình thoi phải là 20');

    // 7. Hình vuông: S = 25, P = 20, d ≈ 7.07
    const pVuong = Presets.getPreset('hinh-vuong').defaultVertices;
    const mVuong = Geometry.computeMeasurements(...pVuong);
    assert.equal(Math.round(mVuong.area), 25, 'Diện tích hình vuông phải là 25');
    assert.equal(Math.round(mVuong.perimeter), 20, 'Chu vi hình vuông phải là 20');
    assert.ok(Math.abs(mVuong.diagonals.AC - 7.07) < 0.02, 'Đường chéo hình vuông ≈ 7.07');

    // 8. Hình diều: S = 24
    const pDieu = Presets.getPreset('hinh-dieu').defaultVertices;
    const mDieu = Geometry.computeMeasurements(...pDieu);
    assert.equal(Math.round(mDieu.area), 24, 'Diện tích hình diều phải là 24');
});

test('Geometry: Kiểm tra tính lồi và từ chối hình lõm, tự cắt theo Mục 8.4', () => {
    // Cả 8 hình mẫu đều phải lồi
    Presets.getAllPresets().forEach(p => {
        const [A, B, C, D] = p.defaultVertices;
        assert.ok(Geometry.isConvex(A, B, C, D), `Hình mẫu ${p.slug} phải là tứ giác lồi hợp lệ`);
    });

    // Hình lõm (đỉnh C lõm vào trong tam giác ABD)
    const concaveQuad = [
        { x: 0, y: 0 },
        { x: 6, y: 0 },
        { x: 2, y: 1 }, // C thụt vào trong
        { x: 0, y: 4 }
    ];
    assert.equal(Geometry.isConvex(...concaveQuad), false, 'Phải từ chối tứ giác lõm');

    // Hình tự cắt (cặp cạnh chéo nhau dạng đồng hồ cát)
    const selfIntersecting = [
        { x: 0, y: 0 },
        { x: 5, y: 5 },
        { x: 5, y: 0 },
        { x: 0, y: 5 }
    ];
    assert.equal(Geometry.isConvex(...selfIntersecting), false, 'Phải từ chối tứ giác tự cắt');

    // Cạnh quá ngắn (< 0.5 cm)
    const tooSmall = [
        { x: 0, y: 0 },
        { x: 0.2, y: 0 },
        { x: 0.2, y: 0.2 },
        { x: 0, y: 0.2 }
    ];
    assert.equal(Geometry.isConvex(...tooSmall), false, 'Phải từ chối hình có cạnh < 0.5 cm hoặc S < 1 cm²');
});
