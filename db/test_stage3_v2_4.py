import urllib.request
import json
import subprocess
import sys

sys.stdout.reconfigure(encoding='utf-8')

def test_stage3():
    print("=== BẮT ĐẦU KIỂM TRA TỰ ĐỘNG GIAI ĐOẠN 3 (XƯỞNG VẼ v2.4) ===")
    
    # 1. Chạy toàn bộ Node Test Runner
    print("1. Chạy toàn bộ 7 Test Suites của Node runner:")
    proc = subprocess.run(["node", "--test", "tests/lab/*.test.js"], capture_output=True, text=True, encoding='utf-8', shell=True)
    if proc.returncode != 0:
        print("[FAIL] Node test runner thất bại:")
        print(proc.stdout)
        print(proc.stderr)
        return False
    print("   -> 7/7 test suites (Geometry, Presets, Classify, Formulas, Transform, UrlSync) ĐẠT (PASS) 100%!")

    # 2. Kiểm tra HTML trang /lab
    base_url = "http://localhost:5200"
    lab_url = f"{base_url}/lab"
    print("2. Kiểm tra cấu trúc HTML và liên kết module trong trang /lab:")
    try:
        req = urllib.request.Request(lab_url)
        with urllib.request.urlopen(req, timeout=10) as resp:
            if resp.getcode() != 200:
                print(f"[FAIL] GET /lab trả về HTTP {resp.getcode()}")
                return False
            html = resp.read().decode('utf-8')
            required_scripts = [
                "geometry.js",
                "presets.js",
                "classify.js",
                "formulas.js",
                "transform.js",
                "url-sync.js",
                "lab.js"
            ]
            for s in required_scripts:
                assert s in html, f"Thiếu script {s} trong trang /lab"
            assert "labPolyFill" in html
            assert "labDiagonalsGroup" in html
            assert "labMarksGroup" in html
            assert "labMeasurementsGroup" in html
            assert "labVerticesGroup" in html
            print("   -> 7/7 file script và các SVG layer groups đều hiện diện đầy đủ")
    except Exception as e:
        print(f"[FAIL] Lỗi kiểm tra /lab: {e}")
        return False

    # 3. Kiểm tra các trang cũ không bị ảnh hưởng
    print("3. Kiểm tra sức khỏe toàn bộ hệ thống:")
    old_routes = ["/", "/shapes", "/practice", "/quiz", "/compare", "/leaderboard", "/search"]
    for r in old_routes:
        try:
            req = urllib.request.Request(f"{base_url}{r}")
            with urllib.request.urlopen(req, timeout=10) as resp:
                assert resp.getcode() == 200
                print(f"   -> {r}: HTTP 200 OK")
        except Exception as e:
            print(f"[FAIL] Lỗi tại {r}: {e}")
            return False

    print("\n>>> TẤT CẢ CÁC MỤC KIỂM TRA GIAI ĐOẠN 3 ĐỀU ĐẠT (PASS) 100%! <<<")
    return True

if __name__ == "__main__":
    success = test_stage3()
    sys.exit(0 if success else 1)
