import neo4j
import sys

sys.stdout.reconfigure(encoding='utf-8')

def main():
    try:
        driver = neo4j.GraphDatabase.driver('bolt://127.0.0.1:7687', auth=('neo4j', '12345678'))
        with driver.session(database='neo4j') as s:
            print("=== KIỂM TRA DỮ LIỆU v2.3 TRONG NEO4J ===")
            # 2.1 Đủ 10/10 cạnh có condition, conditionShort và reason – mong đợi 0
            q21 = '''
                MATCH ()-[r:IS_A]->()
                WHERE r.condition IS NULL OR r.conditionShort IS NULL OR r.reason IS NULL
                RETURN count(r) AS canThieu;
            '''
            res21 = s.run(q21).single()
            can_thieu = res21["canThieu"] if res21 else -1
            print(f"2.1 Số cạnh thiếu condition / conditionShort / reason: {can_thieu} (Mong đợi: 0)")

            # 2.2 Xem 10 cạnh
            q22 = '''
                MATCH (a:Shape)-[r:IS_A]->(b:Shape)
                RETURN a.name AS hinhCon, b.name AS hinhCha, r.conditionShort AS nhan, r.condition AS dieuKien, r.reason AS lyDo
                ORDER BY a.sortOrder, b.sortOrder;
            '''
            edges = s.run(q22).data()
            print(f"2.2 Tổng số cạnh IS_A: {len(edges)}/10")
            for e in edges:
                print(f"   + [{e['hinhCon']}] -> [{e['hinhCha']}]:")
                print(f"       nhan: {e['nhan']}")
                print(f"       dieuKien: {e['dieuKien']}")
                print(f"       lyDo: {e['lyDo'][:60] if e['lyDo'] else None}...")

            # 2.3 Thử truy vấn chi tiết panel: Hình vuông -> Hình chữ nhật
            q23 = '''
                MATCH (c:Shape {slug: 'hinh-vuong'})-[r:IS_A]->(p:Shape {slug: 'hinh-chu-nhat'})
                OPTIONAL MATCH (c)-[:HAS_DEFINITION]->(dc:Definition)
                OPTIONAL MATCH (p)-[:HAS_DEFINITION]->(dp:Definition)
                RETURN c.name AS hinhCon, p.name AS hinhCha, r.condition AS dieuKien, r.reason AS lyDo,
                       dc.content AS dinhNghiaCon, dp.content AS dinhNghiaCha;
            '''
            res23 = s.run(q23).single()
            print(f"2.3 Panel query (hinh-vuong -> hinh-chu-nhat): {'OK' if res23 else 'FAIL'}")

            # 2.4 Tính chất thừa hưởng
            q24 = '''
                MATCH (:Shape {slug: 'hinh-vuong'})-[:IS_A]->(p:Shape {slug: 'hinh-chu-nhat'})
                MATCH (p)-[:IS_A*0..]->(a:Shape)-[:HAS_PROPERTY]->(x:Property)
                RETURN DISTINCT x.id AS id, x.content AS noiDung, a.name AS nguon
                ORDER BY nguon, noiDung;
            '''
            res24 = s.run(q24).data()
            print(f"2.4 Thuộc tính thừa hưởng qua cạnh (hinh-vuong -> hinh-chu-nhat): {len(res24)} tính chất")

        driver.close()
    except Exception as ex:
        print('LỖI KẾT NỐI / TRUY VẤN:', ex)

if __name__ == '__main__':
    main()
