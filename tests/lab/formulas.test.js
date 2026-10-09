const test = require('node:test');
const assert = require('node:assert/strict');
const Presets = require('../../src/QuadWeb/wwwroot/js/lab/presets');
const Formulas = require('../../src/QuadWeb/wwwroot/js/lab/formulas');

test('Formulas: Kiểm chứng chéo các công thức diện tích theo Mục 8.3', () => {
    // 1. Hình thang: F-HT-DIEN-TICH
    const pHT = Presets.getPreset('hinh-thang').defaultVertices;
    const resHT = Formulas.computeFormula('F-HT-DIEN-TICH', ...pHT);
    assert.ok(resHT, 'Phải tính được công thức F-HT-DIEN-TICH');
    assert.ok(resHT.isMatchShoelace, 'Diện tích công thức hình thang phải khớp diện tích tọa độ');
    assert.equal(Math.round(resHT.result), 18);

    // 2. Hình thang cân: F-HT-DIEN-TICH
    const pHTC = Presets.getPreset('hinh-thang-can').defaultVertices;
    const resHTC = Formulas.computeFormula('F-HT-DIEN-TICH', ...pHTC);
    assert.ok(resHTC.isMatchShoelace, 'Diện tích công thức hình thang cân phải khớp tọa độ');
    assert.equal(Math.round(resHTC.result), 18);

    // 3. Hình bình hành: F-HBH-DIEN-TICH
    const pHBH = Presets.getPreset('hinh-binh-hanh').defaultVertices;
    const resHBH = Formulas.computeFormula('F-HBH-DIEN-TICH', ...pHBH);
    assert.ok(resHBH.isMatchShoelace, 'Diện tích công thức hình bình hành phải khớp tọa độ');
    assert.equal(Math.round(resHBH.result), 18);

    // 4. Hình chữ nhật: F-HCN-DIEN-TICH
    const pHCN = Presets.getPreset('hinh-chu-nhat').defaultVertices;
    const resHCN = Formulas.computeFormula('F-HCN-DIEN-TICH', ...pHCN);
    assert.ok(resHCN.isMatchShoelace, 'Diện tích công thức hình chữ nhật phải khớp tọa độ');
    assert.equal(Math.round(resHCN.result), 24);

    // 5. Hình thoi: F-S-HAI-CHEO
    const pThoi = Presets.getPreset('hinh-thoi').defaultVertices;
    const resThoi = Formulas.computeFormula('F-S-HAI-CHEO', ...pThoi);
    assert.ok(resThoi.isMatchShoelace, 'Diện tích công thức hình thoi (hai đường chéo) phải khớp tọa độ');
    assert.equal(Math.round(resThoi.result), 20);

    // 6. Hình vuông: F-VUONG-DIEN-TICH
    const pVuong = Presets.getPreset('hinh-vuong').defaultVertices;
    const resVuong = Formulas.computeFormula('F-VUONG-DIEN-TICH', ...pVuong);
    assert.ok(resVuong.isMatchShoelace, 'Diện tích công thức hình vuông phải khớp tọa độ');
    assert.equal(Math.round(resVuong.result), 25);

    // 7. Hình diều: F-S-HAI-CHEO
    const pDieu = Presets.getPreset('hinh-dieu').defaultVertices;
    const resDieu = Formulas.computeFormula('F-S-HAI-CHEO', ...pDieu);
    assert.ok(resDieu.isMatchShoelace, 'Diện tích công thức hình diều (hai đường chéo) phải khớp tọa độ');
    assert.equal(Math.round(resDieu.result), 24);
});
