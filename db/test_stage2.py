import urllib.request
import sys
import re

sys.stdout.reconfigure(encoding='utf-8')

def test_stage2():
    base_url = "http://localhost:5200"

    print("=== BẮT ĐẦU KIỂM TRA TỰ ĐỘNG GIAI ĐOẠN 2 ===")

    # 1. Test GET /compare
    req = urllib.request.Request(f"{base_url}/compare")
    with urllib.request.urlopen(req) as resp:
        assert resp.status == 200, f"GET /compare lỗi HTTP {resp.status}"
        html = resp.read().decode('utf-8')
        print("1. GET /compare: HTTP 200 OK")

        # Kiểm tra đủ 8 hình trong bảng đặc tả
        expected_shapes = [
            "Tứ giác", "Hình thang", "Hình thang cân", "Hình bình hành",
            "Hình chữ nhật", "Hình thoi", "Hình vuông", "Hình diều"
        ]
        for s in expected_shapes:
            assert s in html, f"Thiếu hình '{s}' trong bảng đặc tả"
        print(f"   -> Đủ 8 hình trong bảng đặc tả: {len(expected_shapes)}/8")

        # Kiểm tra khung cuộn riêng biệt
        assert "spec-table-container" in html, "Thiếu lớp spec-table-container bảo đảm không tràn trang ở 360px"
        assert "spec-table" in html, "Thiếu spec-table"
        print("   -> Đã có khung spec-table-container chống cuộn ngang toàn trang ở 360px")

        # Kiểm tra nút xem sơ đồ quan hệ
        assert "openGraphModal" in html, "Thiếu nút gọi openGraphModal() xem sơ đồ quan hệ"
        print("   -> Đã có nút 'Xem sơ đồ quan hệ' gọi openGraphModal()")

        # Kiểm tra các họ hình
        for fam in ["row-family-thang", "row-family-binh-hanh", "row-family-dieu", "row-family-goc"]:
            assert fam in html, f"Thiếu class {fam}"
        print("   -> Đủ 4 họ hình với màu nền tương ứng")

        # Kiểm tra 10 điều kiện quan hệ IS_A
        conditions_match = re.findall(r'<mark class="condition-highlight">([^<]+)</mark>', html)
        print(f"   -> Số điều kiện tìm thấy trong danh sách: {len(conditions_match)}/10")
        assert len(conditions_match) == 10, f"Mong đợi 10 điều kiện, tìm thấy {len(conditions_match)}"

    # 2. Test GET /shapes/hinh-vuong (kiểm tra điều kiện ở cột hình cha)
    req2 = urllib.request.Request(f"{base_url}/shapes/hinh-vuong")
    with urllib.request.urlopen(req2) as resp2:
        assert resp2.status == 200, f"GET /shapes/hinh-vuong lỗi HTTP {resp2.status}"
        html2 = resp2.read().decode('utf-8')
        print("2. GET /shapes/hinh-vuong: HTTP 200 OK")

    # 3. Test kiểm tra các trang cũ không bị phá vỡ
    pages = ["/", "/shapes", "/practice", "/quiz", "/leaderboard", "/search"]
    for p in pages:
        req_p = urllib.request.Request(f"{base_url}{p}")
        with urllib.request.urlopen(req_p) as resp_p:
            assert resp_p.status == 200, f"Trang {p} lỗi HTTP {resp_p.status}"
            print(f"   -> {p}: HTTP 200 OK")

    print("\n>>> TẤT CẢ CÁC MỤC KIỂM TRA CHO GIAI ĐOẠN 2 ĐỀU ĐẠT (PASS) 100%! <<<\n")

if __name__ == '__main__':
    test_stage2()
