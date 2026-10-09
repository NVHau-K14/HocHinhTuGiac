import urllib.request
import json
import sys

sys.stdout.reconfigure(encoding='utf-8')

def test_stage1():
    print("=== BẮT ĐẦU KIỂM TRA TỰ ĐỘNG GIAI ĐOẠN 1 (XƯỞNG VẼ v2.4) ===")
    base_url = "http://localhost:5200"

    # 1. Kiểm tra API /api/lab/meta
    meta_url = f"{base_url}/api/lab/meta"
    try:
        req = urllib.request.Request(meta_url)
        with urllib.request.urlopen(req, timeout=10) as resp:
            status = resp.getcode()
            if status != 200:
                print(f"[FAIL] GET /api/lab/meta returned HTTP {status}")
                return False
            data = json.loads(resp.read().decode('utf-8'))
            print("1. GET /api/lab/meta: HTTP 200 OK")
            
            shapes = data.get("shapes", [])
            isa = data.get("isa", [])
            formulas = data.get("formulas", [])

            print(f"   -> Số lượng shapes: {len(shapes)} (Kỳ vọng: 8)")
            print(f"   -> Số lượng quan hệ isa: {len(isa)} (Kỳ vọng: 10)")
            print(f"   -> Số lượng formulas: {len(formulas)} (Kỳ vọng: 15)")

            if len(shapes) != 8:
                print(f"[FAIL] Kỳ vọng 8 shapes, thực tế: {len(shapes)}")
                return False
            if len(isa) != 10:
                print(f"[FAIL] Kỳ vọng 10 isa, thực tế: {len(isa)}")
                return False
            if len(formulas) != 15:
                print(f"[FAIL] Kỳ vọng 15 formulas, thực tế: {len(formulas)}")
                return False

            # Kiểm tra trường dữ liệu
            for s in shapes:
                assert "slug" in s and "name" in s and "family" in s and "sortOrder" in s
            for r in isa:
                assert "tu" in r and "den" in r and "condition" in r and "conditionShort" in r
            for f in formulas:
                assert "slug" in f and "id" in f and "name" in f and "expression" in f
            print("   -> Cấu trúc các trường DTO chuẩn xác 100%")

    except Exception as e:
        print(f"[FAIL] Không gọi được {meta_url}: {e}")
        return False

    # 2. Kiểm tra Route /lab
    lab_url = f"{base_url}/lab"
    try:
        req = urllib.request.Request(lab_url)
        with urllib.request.urlopen(req, timeout=10) as resp:
            status = resp.getcode()
            body = resp.read().decode('utf-8')
            print(f"2. GET /lab: HTTP {status} OK")
            assert "Xưởng vẽ hình học tương tác" in body
            assert "labSvgCanvas" in body
            assert "labPresetScroll" in body
            assert "labSceneGroup" in body
            assert "labGrid24" in body
            # Kiểm tra tab active trong menu
            assert 'href="/lab"' in body
            print("   -> Khung trang /lab, SVG Canvas và lưới ô li 24px đầy đủ")
    except Exception as e:
        print(f"[FAIL] Không gọi được {lab_url}: {e}")
        return False

    # 3. Kiểm tra các trang cũ không bị ảnh hưởng (Nguyên tắc 2)
    old_routes = [
        "/",
        "/shapes",
        "/shapes/hinh-chu-nhat",
        "/practice",
        "/quiz",
        "/compare",
        "/compare?a=hinh-thoi&b=hinh-chu-nhat",
        "/leaderboard",
        "/search?q=vuong"
    ]
    print("3. Kiểm tra bảo toàn các trang cũ của hệ thống:")
    for r in old_routes:
        url = f"{base_url}{r}"
        try:
            req = urllib.request.Request(url)
            with urllib.request.urlopen(req, timeout=10) as resp:
                code = resp.getcode()
                if code != 200:
                    print(f"[FAIL] {r} returned {code}")
                    return False
                print(f"   -> {r}: HTTP 200 OK")
        except Exception as e:
            print(f"[FAIL] Lỗi khi truy cập {r}: {e}")
            return False

    print("\n>>> TẤT CẢ CÁC MỤC KIỂM TRA GIAI ĐOẠN 1 ĐỀU ĐẠT (PASS) 100%! <<<")
    return True

if __name__ == "__main__":
    success = test_stage1()
    sys.exit(0 if success else 1)
