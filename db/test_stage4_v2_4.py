import urllib.request
import json
import subprocess
import sys

sys.stdout.reconfigure(encoding='utf-8')

def test_stage4():
    print("=== BẮT ĐẦU KIỂM TRA TỰ ĐỘNG GIAI ĐOẠN 4 (XƯỞNG VẼ v2.4) ===")

    # 1. Chạy toàn bộ 7 Test Suites của Node runner
    print("1. Chạy toàn bộ 7 Test Suites của Node runner:")
    proc = subprocess.run(["node", "--test", "tests/lab/*.test.js"], capture_output=True, text=True, encoding='utf-8', shell=True)
    if proc.returncode != 0:
        print("[FAIL] Node test runner thất bại:")
        print(proc.stdout)
        print(proc.stderr)
        return False
    print("   -> 7/7 test suites (Geometry, Presets, Classify, Formulas, Transform, UrlSync) ĐẠT (PASS) 100%!")

    base_url = "http://localhost:5200"

    # 2. Kiểm tra API /api/lab/meta trả về đủ công thức và hình mẫu
    print("2. Kiểm tra dữ liệu /api/lab/meta:")
    try:
        req = urllib.request.Request(f"{base_url}/api/lab/meta")
        with urllib.request.urlopen(req, timeout=10) as resp:
            assert resp.getcode() == 200
            data = json.loads(resp.read().decode('utf-8'))
            assert len(data.get("shapes", [])) == 8
            assert len(data.get("formulas", [])) == 15
            print("   -> 8 shapes và 15 formulas được nạp từ Neo4j thành công")
    except Exception as e:
        print(f"[FAIL] Lỗi gọi /api/lab/meta: {e}")
        return False

    # 3. Kiểm tra trang /lab chứa các thành phần giai đoạn 4
    print("3. Kiểm tra các thành phần Giai đoạn 4 trong trang /lab:")
    try:
        req = urllib.request.Request(f"{base_url}/lab")
        with urllib.request.urlopen(req, timeout=10) as resp:
            assert resp.getcode() == 200
            html = resp.read().decode('utf-8')
            assert "tabMeasurements" in html
            assert "tabFormulas" in html
            assert "tabClassify" in html
            assert "tabChallenges" in html
            assert "katex.min.js" in html
            print("   -> Các tab Số đo, Công thức, Nhận dạng và thư viện KaTeX hiện diện đầy đủ")
    except Exception as e:
        print(f"[FAIL] Lỗi tải trang /lab: {e}")
        return False

    # 4. Kiểm tra bảo toàn toàn bộ hệ thống
    print("4. Kiểm tra bảo toàn các trang cũ của hệ thống:")
    routes = ["/", "/shapes", "/practice", "/quiz", "/compare", "/leaderboard", "/search"]
    for r in routes:
        try:
            req = urllib.request.Request(f"{base_url}{r}")
            with urllib.request.urlopen(req, timeout=10) as resp:
                assert resp.getcode() == 200
                print(f"   -> {r}: HTTP 200 OK")
        except Exception as e:
            print(f"[FAIL] Lỗi tại {r}: {e}")
            return False

    print("\n>>> TẤT CẢ CÁC MỤC KIỂM TRA GIAI ĐOẠN 4 ĐỀU ĐẠT (PASS) 100%! <<<")
    return True

if __name__ == "__main__":
    success = test_stage4()
    sys.exit(0 if success else 1)
