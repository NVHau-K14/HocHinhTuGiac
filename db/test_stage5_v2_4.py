import urllib.request
import json
import subprocess
import os
import sys

if hasattr(sys.stdout, 'reconfigure'):
    sys.stdout.reconfigure(encoding='utf-8')

BASE_URL = 'http://localhost:5200'

def test_routes():
    routes = [
        '/',
        '/shapes',
        '/practice',
        '/quiz',
        '/compare',
        '/leaderboard',
        '/search',
        '/lab'
    ]
    print("=== 1. KIỂM TRA 8 ROUTE WEB ===")
    for r in routes:
        url = BASE_URL + r
        req = urllib.request.Request(url, headers={'User-Agent': 'Mozilla/5.0'})
        with urllib.request.urlopen(req, timeout=5) as res:
            assert res.status == 200, f"Route {r} failed with status {res.status}"
            content = res.read().decode('utf-8')
            if r == '/lab':
                assert 'labBtnDownloadSvg' in content, "labBtnDownloadSvg missing"
                assert 'labBtnDownloadPng' in content, "labBtnDownloadPng missing"
                assert 'labLayerAxesSym' in content, "labLayerAxesSym missing"
                assert 'labSymmetryGroup' in content, "labSymmetryGroup missing"
            print(f"  ✓ {r:15} -> HTTP {res.status} OK")

def test_api():
    print("\n=== 2. KIỂM TRA API /api/lab/meta ===")
    url = BASE_URL + '/api/lab/meta'
    req = urllib.request.Request(url, headers={'User-Agent': 'Mozilla/5.0'})
    with urllib.request.urlopen(req, timeout=5) as res:
        assert res.status == 200
        data = json.loads(res.read().decode('utf-8'))
        assert len(data.get('shapes', [])) == 8, f"Expected 8 shapes, got {len(data.get('shapes', []))}"
        assert len(data.get('isa', [])) >= 10, f"Expected >= 10 relations, got {len(data.get('isa', []))}"
        assert len(data.get('formulas', [])) >= 11, f"Expected formulas, got {len(data.get('formulas', []))}"
        print(f"  ✓ Shapes: {len(data['shapes'])}, Relations: {len(data['isa'])}, Formulas: {len(data['formulas'])}")

def capture_screenshots():
    print("\n=== 3. CHỤP ẢNH MÀN HÌNH HEADLESS CHROME ===")
    chrome_path = r'C:\Program Files\Google\Chrome\Application\chrome.exe'
    if not os.path.exists(chrome_path):
        print("  Không tìm thấy Chrome, bỏ qua chụp ảnh.")
        return

    out_dir = os.path.join(os.path.dirname(__file__), '..', 'docs', 'screenshots')
    os.makedirs(out_dir, exist_ok=True)

    # 1. Desktop 1280x850
    desktop_png = os.path.abspath(os.path.join(out_dir, 'lab_stage5_desktop.png'))
    cmd_desk = [
        chrome_path,
        '--headless=new',
        f'--screenshot={desktop_png}',
        '--window-size=1280,850',
        'http://localhost:5200/lab'
    ]
    subprocess.run(cmd_desk, check=True)
    print(f"  ✓ Đã chụp ảnh Desktop: {desktop_png} ({os.path.getsize(desktop_png)} bytes)")

    # 2. Mobile 360x780
    mobile_png = os.path.abspath(os.path.join(out_dir, 'lab_stage5_mobile.png'))
    cmd_mob = [
        chrome_path,
        '--headless=new',
        f'--screenshot={mobile_png}',
        '--window-size=360,780',
        'http://localhost:5200/lab'
    ]
    subprocess.run(cmd_mob, check=True)
    print(f"  ✓ Đã chụp ảnh Mobile: {mobile_png} ({os.path.getsize(mobile_png)} bytes)")

if __name__ == '__main__':
    try:
        test_routes()
        test_api()
        capture_screenshots()
        print("\n🎉 TOÀN BỘ KIỂM TRA GIAI ĐOẠN 5 THÀNH CÔNG RỰC RỠ!")
    except Exception as e:
        print(f"\n❌ LỖI: {e}")
        sys.exit(1)
