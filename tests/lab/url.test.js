const test = require('node:test');
const assert = require('node:assert/strict');
const UrlSync = require('../../src/QuadWeb/wwwroot/js/lab/url-sync');

test('UrlSync: Phân tích URL hợp lệ và từ chối URL xấu theo Mục 8.7', () => {
    // 1. URL hợp lệ chế độ hình mẫu
    const validParamQuery = '?shape=hinh-chu-nhat&a=6&b=4&snap=1&step=1';
    const stateParam = UrlSync.parseUrlToState(validParamQuery);
    assert.ok(stateParam.isValid, 'URL hình mẫu hợp lệ phải được chấp nhận');
    assert.equal(stateParam.activePreset, 'hinh-chu-nhat');
    assert.equal(stateParam.params.a, 6);
    assert.equal(stateParam.params.b, 4);

    // 2. URL hợp lệ chế độ tự do
    const validFreeQuery = '?mode=free&pts=0,0;6,0;6,4;0,4&snap=1&step=1';
    const stateFree = UrlSync.parseUrlToState(validFreeQuery);
    assert.ok(stateFree.isValid, 'URL tự do hợp lệ phải được chấp nhận');
    assert.equal(stateFree.mode, 'free');
    assert.equal(stateFree.vertices.length, 4);

    // 3. URL xấu: Tọa độ chứa NaN
    const badNanQuery = '?mode=free&pts=0,0;NaN,0;6,4;0,4';
    const stateNan = UrlSync.parseUrlToState(badNanQuery);
    assert.equal(stateNan.isValid, false, 'Phải từ chối URL chứa NaN');

    // 4. URL xấu: Tọa độ vượt giới hạn > 50 cm
    const badLimitQuery = '?mode=free&pts=0,0;999,0;6,4;0,4';
    const stateLimit = UrlSync.parseUrlToState(badLimitQuery);
    assert.equal(stateLimit.isValid, false, 'Phải từ chối URL tọa độ vượt giới hạn');

    // 5. URL xấu: Tứ giác bị lõm
    const badConcaveQuery = '?mode=free&pts=0,0;6,0;2,1;0,4';
    const stateConcave = UrlSync.parseUrlToState(badConcaveQuery);
    assert.equal(stateConcave.isValid, false, 'Phải từ chối URL tứ giác lõm');

    // 6. Serialize và Parse đối xứng
    const testState = {
        mode: 'param',
        activePreset: 'hinh-vuong',
        params: { a: 5 },
        snap: true,
        snapStep: 1
    };
    const serialized = UrlSync.serializeStateToUrl(testState);
    const parsedBack = UrlSync.parseUrlToState(serialized);
    assert.ok(parsedBack.isValid);
    assert.equal(parsedBack.activePreset, 'hinh-vuong');
    assert.equal(parsedBack.params.a, 5);
});
