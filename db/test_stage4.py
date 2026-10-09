import urllib.request
import json
import sys

sys.stdout.reconfigure(encoding='utf-8')

def test_stage4():
    base_url = "http://localhost:5200"
    print("=== BẮT ĐẦU KIỂM TRA TỰ ĐỘNG GIAI ĐOẠN 4 ===")

    # 1. Test GET /api/relation?child=hinh-vuong&parent=hinh-chu-nhat
    url1 = f"{base_url}/api/relation?child=hinh-vuong&parent=hinh-chu-nhat"
    req1 = urllib.request.Request(url1)
    with urllib.request.urlopen(req1) as resp:
        assert resp.status == 200, f"Lỗi HTTP {resp.status}"
        data = json.loads(resp.read().decode('utf-8'))
        print("1. GET /api/relation (Hình vuông -> Hình chữ nhật): HTTP 200 OK")
        print(f"   -> ChildName: {data.get('childName')}, ParentName: {data.get('parentName')}")
        print(f"   -> Condition: {data.get('condition')}")
        print(f"   -> Reason: {data.get('reason')}")
        print(f"   -> ChildDefinition: {data.get('childDefinition')[:50]}...")
        print(f"   -> ParentDefinition: {data.get('parentDefinition')[:50]}...")
        print(f"   -> Số tính chất thừa hưởng: {len(data.get('inheritedProperties', []))}")
        
        assert data.get('childName') == "Hình vuông"
        assert data.get('parentName') == "Hình chữ nhật"
        assert "cạnh kề" in data.get('condition', '').lower()
        assert data.get('reason') is not None
        assert len(data.get('inheritedProperties', [])) > 0

    # 2. Test GET /api/relation (Hình thoi -> Hình diều)
    url2 = f"{base_url}/api/relation?child=hinh-thoi&parent=hinh-dieu"
    with urllib.request.urlopen(url2) as resp:
        assert resp.status == 200
        data2 = json.loads(resp.read().decode('utf-8'))
        print("2. GET /api/relation (Hình thoi -> Hình diều): HTTP 200 OK")
        print(f"   -> Condition: {data2.get('condition')}")
        assert data2.get('childName') == "Hình thoi"
        assert data2.get('parentName') == "Hình diều"

    # 3. Test quan hệ không tồn tại (404)
    url_invalid = f"{base_url}/api/relation?child=hinh-vuong&parent=tu-giac"
    try:
        urllib.request.urlopen(url_invalid)
        assert False, "Mong đợi lỗi 404 cho quan hệ không trực tiếp"
    except urllib.error.HTTPError as ex:
        assert ex.code == 404, f"Mong đợi 404 nhưng nhận {ex.code}"
        print(f"3. GET /api/relation (Quan hệ không trực tiếp): HTTP 404 Not Found (Chính xác)")

    # 4. Kiểm tra trang /compare chứa đầy đủ HTML panel 6 mục
    with urllib.request.urlopen(f"{base_url}/compare") as resp:
        html = resp.read().decode('utf-8')
        assert "edgeDetailPanel" in html, "Thiếu edgeDetailPanel"
        assert "panelEdgeTitle" in html, "Thiếu panelEdgeTitle"
        assert "panelEdgeFormula" in html, "Thiếu panelEdgeFormula"
        assert "panelSectionReason" in html, "Thiếu panelSectionReason"
        assert "panelSectionProps" in html, "Thiếu panelSectionProps"
        assert "btnPanelCompare" in html, "Thiếu btnPanelCompare"
        assert "btnModeCondition" in html, "Thiếu nút chuyển mode"
        assert "btnModeIsA" in html, "Thiếu nút chuyển mode"
        print("4. Trang /compare: Chứa đầy đủ cấu trúc Panel 6 mục và bộ chuyển mode")

    # 5. Kiểm tra các trang cũ không bị phá vỡ
    pages = ["/", "/shapes", "/shapes/hinh-vuong", "/compare", "/practice", "/quiz", "/leaderboard", "/search?q=goc"]
    for p in pages:
        with urllib.request.urlopen(f"{base_url}{p}") as resp:
            assert resp.status == 200, f"Trang {p} lỗi {resp.status}"
    print(f"5. Kiểm tra 8/8 trang hệ thống: Tất cả đều HTTP 200 OK")

    print("\n>>> TẤT CẢ CÁC MỤC KIỂM TRA GIAI ĐOẠN 4 ĐỀU ĐẠT (PASS) 100%! <<<\n")

if __name__ == '__main__':
    test_stage4()
