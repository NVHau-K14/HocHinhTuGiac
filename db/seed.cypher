// ============================================================================
// SEED SCRIPT CHO HỆ THỐNG HỌC HÌNH HỌC PHẲNG: TỨ GIÁC (NEO4J)
// Đáp ứng đầy đủ 8 Shape, 10 IS_A, >= 40 Question với 4 AnswerOption và lời giải.
// Chạy lặp được (MERGE) không gây trùng lặp.
// ============================================================================

// --------------------------------------------------
// 1. KHỞI TẠO 8 HÌNH (SHAPES)
// --------------------------------------------------

MERGE (s:Shape {slug: 'tu-giac'})
ON CREATE SET s.id = 'S-TU-GIAC',
              s.name = 'Tứ giác',
              s.shortDescription = "Hình có bốn đỉnh, bốn cạnh; tổng bốn góc bằng 360°.",
              s.searchText = "tu giac  hinh co bon dinh, bon canh; tong bon goc bang 360°.  ",
              s.sortOrder = 1,
              s.family = "goc"
ON MATCH SET s.name = 'Tứ giác',
             s.shortDescription = "Hình có bốn đỉnh, bốn cạnh; tổng bốn góc bằng 360°.",
             s.searchText = "tu giac  hinh co bon dinh, bon canh; tong bon goc bang 360°.  ",
             s.sortOrder = 1,
             s.family = "goc";

MERGE (s:Shape {slug: 'hinh-thang'})
ON CREATE SET s.id = 'S-HINH-THANG',
              s.name = 'Hình thang',
              s.shortDescription = "Tứ giác có ít nhất một cặp cạnh đối song song.",
              s.searchText = "hinh thang  tu giac co it nhat mot cap canh doi song song.  ",
              s.sortOrder = 2,
              s.family = "thang"
ON MATCH SET s.name = 'Hình thang',
             s.shortDescription = "Tứ giác có ít nhất một cặp cạnh đối song song.",
             s.searchText = "hinh thang  tu giac co it nhat mot cap canh doi song song.  ",
             s.sortOrder = 2,
             s.family = "thang";

MERGE (s:Shape {slug: 'hinh-thang-can'})
ON CREATE SET s.id = 'S-HINH-THANG-CAN',
              s.name = 'Hình thang cân',
              s.shortDescription = "Hình thang có hai góc kề một đáy bằng nhau.",
              s.searchText = "hinh thang can  hinh thang co hai goc ke mot day bang nhau.  ",
              s.sortOrder = 3,
              s.family = "thang"
ON MATCH SET s.name = 'Hình thang cân',
             s.shortDescription = "Hình thang có hai góc kề một đáy bằng nhau.",
             s.searchText = "hinh thang can  hinh thang co hai goc ke mot day bang nhau.  ",
             s.sortOrder = 3,
             s.family = "thang";

MERGE (s:Shape {slug: 'hinh-binh-hanh'})
ON CREATE SET s.id = 'S-HINH-BINH-HANH',
              s.name = 'Hình bình hành',
              s.shortDescription = "Tứ giác có hai cặp cạnh đối song song.",
              s.searchText = "hinh binh hanh  tu giac co hai cap canh doi song song.  ",
              s.sortOrder = 4,
              s.family = "binh-hanh"
ON MATCH SET s.name = 'Hình bình hành',
             s.shortDescription = "Tứ giác có hai cặp cạnh đối song song.",
             s.searchText = "hinh binh hanh  tu giac co hai cap canh doi song song.  ",
             s.sortOrder = 4,
             s.family = "binh-hanh";

MERGE (s:Shape {slug: 'hinh-chu-nhat'})
ON CREATE SET s.id = 'S-HINH-CHU-NHAT',
              s.name = 'Hình chữ nhật',
              s.shortDescription = "Tứ giác có bốn góc vuông.",
              s.searchText = "hinh chu nhat  tu giac co bon goc vuong.  ",
              s.sortOrder = 5,
              s.family = "binh-hanh"
ON MATCH SET s.name = 'Hình chữ nhật',
             s.shortDescription = "Tứ giác có bốn góc vuông.",
             s.searchText = "hinh chu nhat  tu giac co bon goc vuong.  ",
             s.sortOrder = 5,
             s.family = "binh-hanh";

MERGE (s:Shape {slug: 'hinh-thoi'})
ON CREATE SET s.id = 'S-HINH-THOI',
              s.name = 'Hình thoi',
              s.shortDescription = "Tứ giác có bốn cạnh bằng nhau.",
              s.searchText = "hinh thoi  tu giac co bon canh bang nhau.  ",
              s.sortOrder = 6,
              s.family = "binh-hanh"
ON MATCH SET s.name = 'Hình thoi',
             s.shortDescription = "Tứ giác có bốn cạnh bằng nhau.",
             s.searchText = "hinh thoi  tu giac co bon canh bang nhau.  ",
             s.sortOrder = 6,
             s.family = "binh-hanh";

MERGE (s:Shape {slug: 'hinh-vuong'})
ON CREATE SET s.id = 'S-HINH-VUONG',
              s.name = 'Hình vuông',
              s.shortDescription = "Tứ giác có bốn góc vuông và bốn cạnh bằng nhau.",
              s.searchText = "hinh vuong  tu giac co bon goc vuong va bon canh bang nhau.  ",
              s.sortOrder = 7,
              s.family = "binh-hanh"
ON MATCH SET s.name = 'Hình vuông',
             s.shortDescription = "Tứ giác có bốn góc vuông và bốn cạnh bằng nhau.",
             s.searchText = "hinh vuong  tu giac co bon goc vuong va bon canh bang nhau.  ",
             s.sortOrder = 7,
             s.family = "binh-hanh";

MERGE (s:Shape {slug: 'hinh-dieu'})
ON CREATE SET s.id = 'S-HINH-DIEU',
              s.name = 'Hình diều',
              s.shortDescription = "Tứ giác có hai cặp cạnh kề bằng nhau.",
              s.searchText = "hinh dieu  tu giac co hai cap canh ke bang nhau.  ",
              s.sortOrder = 8,
              s.family = "dieu"
ON MATCH SET s.name = 'Hình diều',
             s.shortDescription = "Tứ giác có hai cặp cạnh kề bằng nhau.",
             s.searchText = "hinh dieu  tu giac co hai cap canh ke bang nhau.  ",
             s.sortOrder = 8,
             s.family = "dieu";


// --------------------------------------------------
// 2. QUAN HỆ KẾ THỪA IS_A (ĐÚNG 10 CẠNH: HÌNH ĐẶC BIỆT -> HÌNH TỔNG QUÁT)
// --------------------------------------------------

MATCH (child:Shape {slug: 'hinh-binh-hanh'}), (parent:Shape {slug: 'hinh-thang'})
MERGE (child)-[:IS_A]->(parent);

MATCH (child:Shape {slug: 'hinh-chu-nhat'}), (parent:Shape {slug: 'hinh-binh-hanh'})
MERGE (child)-[:IS_A]->(parent);

MATCH (child:Shape {slug: 'hinh-chu-nhat'}), (parent:Shape {slug: 'hinh-thang-can'})
MERGE (child)-[:IS_A]->(parent);

MATCH (child:Shape {slug: 'hinh-dieu'}), (parent:Shape {slug: 'tu-giac'})
MERGE (child)-[:IS_A]->(parent);

MATCH (child:Shape {slug: 'hinh-thang'}), (parent:Shape {slug: 'tu-giac'})
MERGE (child)-[:IS_A]->(parent);

MATCH (child:Shape {slug: 'hinh-thang-can'}), (parent:Shape {slug: 'hinh-thang'})
MERGE (child)-[:IS_A]->(parent);

MATCH (child:Shape {slug: 'hinh-thoi'}), (parent:Shape {slug: 'hinh-binh-hanh'})
MERGE (child)-[:IS_A]->(parent);

MATCH (child:Shape {slug: 'hinh-thoi'}), (parent:Shape {slug: 'hinh-dieu'})
MERGE (child)-[:IS_A]->(parent);

MATCH (child:Shape {slug: 'hinh-vuong'}), (parent:Shape {slug: 'hinh-chu-nhat'})
MERGE (child)-[:IS_A]->(parent);

MATCH (child:Shape {slug: 'hinh-vuong'}), (parent:Shape {slug: 'hinh-thoi'})
MERGE (child)-[:IS_A]->(parent);


// --------------------------------------------------
// 3. ĐỊNH NGHĨA (DEFINITIONS)
// --------------------------------------------------

MERGE (d:Definition {id: 'D-HINH-BINH-HANH'})
ON CREATE SET d.content = "Hình bình hành là tứ giác có hai cặp cạnh đối song song.",
              d.note = "",
              d.searchText = "   hinh binh hanh la tu giac co hai cap canh doi song song. "
ON MATCH SET d.content = "Hình bình hành là tứ giác có hai cặp cạnh đối song song.",
             d.note = "",
             d.searchText = "   hinh binh hanh la tu giac co hai cap canh doi song song. "
WITH d
MATCH (s:Shape {slug: 'hinh-binh-hanh'})
MERGE (s)-[:HAS_DEFINITION]->(d);

MERGE (d:Definition {id: 'D-HINH-CHU-NHAT'})
ON CREATE SET d.content = "Hình chữ nhật là tứ giác có bốn góc vuông.",
              d.note = "",
              d.searchText = "   hinh chu nhat la tu giac co bon goc vuong. "
ON MATCH SET d.content = "Hình chữ nhật là tứ giác có bốn góc vuông.",
             d.note = "",
             d.searchText = "   hinh chu nhat la tu giac co bon goc vuong. "
WITH d
MATCH (s:Shape {slug: 'hinh-chu-nhat'})
MERGE (s)-[:HAS_DEFINITION]->(d);

MERGE (d:Definition {id: 'D-HINH-DIEU'})
ON CREATE SET d.content = "Hình diều là tứ giác có hai cặp cạnh kề bằng nhau. Đây là định nghĩa nhóm chọn: theo định nghĩa này, hình thoi là một trường hợp đặc biệt của hình diều.",
              d.note = "",
              d.searchText = "   hinh dieu la tu giac co hai cap canh ke bang nhau. day la dinh nghia nhom chon: theo dinh nghia nay, hinh thoi la mot truong hop dac biet cua hinh dieu. "
ON MATCH SET d.content = "Hình diều là tứ giác có hai cặp cạnh kề bằng nhau. Đây là định nghĩa nhóm chọn: theo định nghĩa này, hình thoi là một trường hợp đặc biệt của hình diều.",
             d.note = "",
             d.searchText = "   hinh dieu la tu giac co hai cap canh ke bang nhau. day la dinh nghia nhom chon: theo dinh nghia nay, hinh thoi la mot truong hop dac biet cua hinh dieu. "
WITH d
MATCH (s:Shape {slug: 'hinh-dieu'})
MERGE (s)-[:HAS_DEFINITION]->(d);

MERGE (d:Definition {id: 'D-HINH-THANG'})
ON CREATE SET d.content = "Hình thang là tứ giác có ít nhất một cặp cạnh đối song song. Hai cạnh song song gọi là hai đáy, hai cạnh còn lại gọi là hai cạnh bên.",
              d.note = "",
              d.searchText = "   hinh thang la tu giac co it nhat mot cap canh doi song song. hai canh song song goi la hai day, hai canh con lai goi la hai canh ben. "
ON MATCH SET d.content = "Hình thang là tứ giác có ít nhất một cặp cạnh đối song song. Hai cạnh song song gọi là hai đáy, hai cạnh còn lại gọi là hai cạnh bên.",
             d.note = "",
             d.searchText = "   hinh thang la tu giac co it nhat mot cap canh doi song song. hai canh song song goi la hai day, hai canh con lai goi la hai canh ben. "
WITH d
MATCH (s:Shape {slug: 'hinh-thang'})
MERGE (s)-[:HAS_DEFINITION]->(d);

MERGE (d:Definition {id: 'D-HINH-THANG-CAN'})
ON CREATE SET d.content = "Hình thang cân là hình thang có hai góc kề một đáy bằng nhau.",
              d.note = "",
              d.searchText = "   hinh thang can la hinh thang co hai goc ke mot day bang nhau. "
ON MATCH SET d.content = "Hình thang cân là hình thang có hai góc kề một đáy bằng nhau.",
             d.note = "",
             d.searchText = "   hinh thang can la hinh thang co hai goc ke mot day bang nhau. "
WITH d
MATCH (s:Shape {slug: 'hinh-thang-can'})
MERGE (s)-[:HAS_DEFINITION]->(d);

MERGE (d:Definition {id: 'D-HINH-THOI'})
ON CREATE SET d.content = "Hình thoi là tứ giác có bốn cạnh bằng nhau.",
              d.note = "",
              d.searchText = "   hinh thoi la tu giac co bon canh bang nhau. "
ON MATCH SET d.content = "Hình thoi là tứ giác có bốn cạnh bằng nhau.",
             d.note = "",
             d.searchText = "   hinh thoi la tu giac co bon canh bang nhau. "
WITH d
MATCH (s:Shape {slug: 'hinh-thoi'})
MERGE (s)-[:HAS_DEFINITION]->(d);

MERGE (d:Definition {id: 'D-HINH-VUONG'})
ON CREATE SET d.content = "Hình vuông là tứ giác có bốn góc vuông và bốn cạnh bằng nhau.",
              d.note = "",
              d.searchText = "   hinh vuong la tu giac co bon goc vuong va bon canh bang nhau. "
ON MATCH SET d.content = "Hình vuông là tứ giác có bốn góc vuông và bốn cạnh bằng nhau.",
             d.note = "",
             d.searchText = "   hinh vuong la tu giac co bon goc vuong va bon canh bang nhau. "
WITH d
MATCH (s:Shape {slug: 'hinh-vuong'})
MERGE (s)-[:HAS_DEFINITION]->(d);

MERGE (d:Definition {id: 'D-TU-GIAC'})
ON CREATE SET d.content = "Tứ giác ABCD là hình gồm bốn đoạn thẳng AB, BC, CD, DA nối tiếp nhau thành một đường gấp khúc khép kín, không tự cắt, trong đó ba đỉnh liên tiếp không thẳng hàng.",
              d.note = "",
              d.searchText = "   tu giac abcd la hinh gom bon doan thang ab, bc, cd, da noi tiep nhau thanh mot duong gap khuc khep kin, khong tu cat, trong do ba dinh lien tiep khong thang hang. "
ON MATCH SET d.content = "Tứ giác ABCD là hình gồm bốn đoạn thẳng AB, BC, CD, DA nối tiếp nhau thành một đường gấp khúc khép kín, không tự cắt, trong đó ba đỉnh liên tiếp không thẳng hàng.",
             d.note = "",
             d.searchText = "   tu giac abcd la hinh gom bon doan thang ab, bc, cd, da noi tiep nhau thanh mot duong gap khuc khep kin, khong tu cat, trong do ba dinh lien tiep khong thang hang. "
WITH d
MATCH (s:Shape {slug: 'tu-giac'})
MERGE (s)-[:HAS_DEFINITION]->(d);


// --------------------------------------------------
// 4. TÍNH CHẤT (PROPERTIES - GỒM PROPERTY DÙNG CHUNG KẾ THỪA QUA IS_A)
// --------------------------------------------------

MERGE (p:Property {id: 'P-DIEU-CANH-KE'})
ON CREATE SET p.content = "Có hai cặp cạnh kề bằng nhau.",
              p.searchText = "   co hai cap canh ke bang nhau. "
ON MATCH SET p.content = "Có hai cặp cạnh kề bằng nhau.",
             p.searchText = "   co hai cap canh ke bang nhau. ";

MERGE (p:Property {id: 'P-DIEU-GOC-DOI'})
ON CREATE SET p.content = "Có một cặp góc đối bằng nhau (hai góc ở hai đầu của đường chéo không phải trục đối xứng).",
              p.searchText = "   co mot cap goc doi bang nhau (hai goc o hai dau cua duong cheo khong phai truc doi xung). "
ON MATCH SET p.content = "Có một cặp góc đối bằng nhau (hai góc ở hai đầu của đường chéo không phải trục đối xứng).",
             p.searchText = "   co mot cap goc doi bang nhau (hai goc o hai dau cua duong cheo khong phai truc doi xung). ";

MERGE (p:Property {id: 'P-DIEU-TRUC-DOI-XUNG'})
ON CREATE SET p.content = "Có một đường chéo là trục đối xứng; đường chéo này là đường trung trực của đường chéo còn lại.",
              p.searchText = "   co mot duong cheo la truc doi xung; duong cheo nay la duong trung truc cua duong cheo con lai. "
ON MATCH SET p.content = "Có một đường chéo là trục đối xứng; đường chéo này là đường trung trực của đường chéo còn lại.",
             p.searchText = "   co mot duong cheo la truc doi xung; duong cheo nay la duong trung truc cua duong cheo con lai. ";

MERGE (p:Property {id: 'P-DUONG-CHEO-VUONG-GOC'})
ON CREATE SET p.content = "Hai đường chéo vuông góc với nhau.",
              p.searchText = "   hai duong cheo vuong goc voi nhau. "
ON MATCH SET p.content = "Hai đường chéo vuông góc với nhau.",
             p.searchText = "   hai duong cheo vuong goc voi nhau. ";

MERGE (p:Property {id: 'P-HBH-CANH-DOI'})
ON CREATE SET p.content = "Các cạnh đối song song và bằng nhau.",
              p.searchText = "   cac canh doi song song va bang nhau. "
ON MATCH SET p.content = "Các cạnh đối song song và bằng nhau.",
             p.searchText = "   cac canh doi song song va bang nhau. ";

MERGE (p:Property {id: 'P-HBH-CHEO-TRUNG-DIEM'})
ON CREATE SET p.content = "Hai đường chéo cắt nhau tại trung điểm của mỗi đường.",
              p.searchText = "   hai duong cheo cat nhau tai trung diem cua moi duong. "
ON MATCH SET p.content = "Hai đường chéo cắt nhau tại trung điểm của mỗi đường.",
             p.searchText = "   hai duong cheo cat nhau tai trung diem cua moi duong. ";

MERGE (p:Property {id: 'P-HBH-GOC-DOI'})
ON CREATE SET p.content = "Các góc đối bằng nhau.",
              p.searchText = "   cac goc doi bang nhau. "
ON MATCH SET p.content = "Các góc đối bằng nhau.",
             p.searchText = "   cac goc doi bang nhau. ";

MERGE (p:Property {id: 'P-HBH-TAM-DOI-XUNG'})
ON CREATE SET p.content = "Giao điểm của hai đường chéo là tâm đối xứng của hình.",
              p.searchText = "   giao diem cua hai duong cheo la tam doi xung cua hinh. "
ON MATCH SET p.content = "Giao điểm của hai đường chéo là tâm đối xứng của hình.",
             p.searchText = "   giao diem cua hai duong cheo la tam doi xung cua hinh. ";

MERGE (p:Property {id: 'P-HCN-BON-GOC-VUONG'})
ON CREATE SET p.content = "Bốn góc đều là góc vuông (90°).",
              p.searchText = "   bon goc deu la goc vuong (90°). "
ON MATCH SET p.content = "Bốn góc đều là góc vuông (90°).",
             p.searchText = "   bon goc deu la goc vuong (90°). ";

MERGE (p:Property {id: 'P-HCN-HAI-TRUC'})
ON CREATE SET p.content = "Có hai trục đối xứng là hai đường thẳng đi qua trung điểm của các cặp cạnh đối.",
              p.searchText = "   co hai truc doi xung la hai duong thang di qua trung diem cua cac cap canh doi. "
ON MATCH SET p.content = "Có hai trục đối xứng là hai đường thẳng đi qua trung điểm của các cặp cạnh đối.",
             p.searchText = "   co hai truc doi xung la hai duong thang di qua trung diem cua cac cap canh doi. ";

MERGE (p:Property {id: 'P-HT-CAP-SONG-SONG'})
ON CREATE SET p.content = "Có ít nhất một cặp cạnh đối song song.",
              p.searchText = "   co it nhat mot cap canh doi song song. "
ON MATCH SET p.content = "Có ít nhất một cặp cạnh đối song song.",
             p.searchText = "   co it nhat mot cap canh doi song song. ";

MERGE (p:Property {id: 'P-HT-DUONG-TRUNG-BINH'})
ON CREATE SET p.content = "Đường trung bình của hình thang song song với hai đáy và bằng nửa tổng hai đáy.",
              p.searchText = "   duong trung binh cua hinh thang song song voi hai day va bang nua tong hai day. "
ON MATCH SET p.content = "Đường trung bình của hình thang song song với hai đáy và bằng nửa tổng hai đáy.",
             p.searchText = "   duong trung binh cua hinh thang song song voi hai day va bang nua tong hai day. ";

MERGE (p:Property {id: 'P-HT-GOC-KE-BEN'})
ON CREATE SET p.content = "Hai góc kề một cạnh bên của hình thang bù nhau (tổng bằng 180°).",
              p.searchText = "   hai goc ke mot canh ben cua hinh thang bu nhau (tong bang 180°). "
ON MATCH SET p.content = "Hai góc kề một cạnh bên của hình thang bù nhau (tổng bằng 180°).",
             p.searchText = "   hai goc ke mot canh ben cua hinh thang bu nhau (tong bang 180°). ";

MERGE (p:Property {id: 'P-HTC-CANH-BEN'})
ON CREATE SET p.content = "Hai cạnh bên bằng nhau.",
              p.searchText = "   hai canh ben bang nhau. "
ON MATCH SET p.content = "Hai cạnh bên bằng nhau.",
             p.searchText = "   hai canh ben bang nhau. ";

MERGE (p:Property {id: 'P-HTC-CHEO-BANG'})
ON CREATE SET p.content = "Hai đường chéo bằng nhau.",
              p.searchText = "   hai duong cheo bang nhau. "
ON MATCH SET p.content = "Hai đường chéo bằng nhau.",
             p.searchText = "   hai duong cheo bang nhau. ";

MERGE (p:Property {id: 'P-HTC-GOC-DAY'})
ON CREATE SET p.content = "Hai góc kề một đáy bằng nhau.",
              p.searchText = "   hai goc ke mot day bang nhau. "
ON MATCH SET p.content = "Hai góc kề một đáy bằng nhau.",
             p.searchText = "   hai goc ke mot day bang nhau. ";

MERGE (p:Property {id: 'P-HTC-NOI-TIEP'})
ON CREATE SET p.content = "Bốn đỉnh cùng nằm trên một đường tròn (nội tiếp được đường tròn).",
              p.searchText = "   bon dinh cung nam tren mot duong tron (noi tiep duoc duong tron). "
ON MATCH SET p.content = "Bốn đỉnh cùng nằm trên một đường tròn (nội tiếp được đường tròn).",
             p.searchText = "   bon dinh cung nam tren mot duong tron (noi tiep duoc duong tron). ";

MERGE (p:Property {id: 'P-TG-CANH-NHO-HON'})
ON CREATE SET p.content = "Độ dài mỗi cạnh của tứ giác nhỏ hơn tổng độ dài ba cạnh còn lại.",
              p.searchText = "   do dai moi canh cua tu giac nho hon tong do dai ba canh con lai. "
ON MATCH SET p.content = "Độ dài mỗi cạnh của tứ giác nhỏ hơn tổng độ dài ba cạnh còn lại.",
             p.searchText = "   do dai moi canh cua tu giac nho hon tong do dai ba canh con lai. ";

MERGE (p:Property {id: 'P-TG-DINH-CANH-CHEO'})
ON CREATE SET p.content = "Tứ giác có 4 đỉnh, 4 cạnh và 2 đường chéo.",
              p.searchText = "   tu giac co 4 dinh, 4 canh va 2 duong cheo. "
ON MATCH SET p.content = "Tứ giác có 4 đỉnh, 4 cạnh và 2 đường chéo.",
             p.searchText = "   tu giac co 4 dinh, 4 canh va 2 duong cheo. ";

MERGE (p:Property {id: 'P-TG-TONG-GOC'})
ON CREATE SET p.content = "Tổng bốn góc của một tứ giác bằng 360°.",
              p.searchText = "   tong bon goc cua mot tu giac bang 360°. "
ON MATCH SET p.content = "Tổng bốn góc của một tứ giác bằng 360°.",
             p.searchText = "   tong bon goc cua mot tu giac bang 360°. ";

MERGE (p:Property {id: 'P-THOI-BON-CANH'})
ON CREATE SET p.content = "Bốn cạnh bằng nhau.",
              p.searchText = "   bon canh bang nhau. "
ON MATCH SET p.content = "Bốn cạnh bằng nhau.",
             p.searchText = "   bon canh bang nhau. ";

MERGE (p:Property {id: 'P-THOI-CHEO-PHAN-GIAC'})
ON CREATE SET p.content = "Hai đường chéo là các đường phân giác của các góc của hình thoi.",
              p.searchText = "   hai duong cheo la cac duong phan giac cua cac goc cua hinh thoi. "
ON MATCH SET p.content = "Hai đường chéo là các đường phân giác của các góc của hình thoi.",
             p.searchText = "   hai duong cheo la cac duong phan giac cua cac goc cua hinh thoi. ";

MERGE (p:Property {id: 'P-THOI-HAI-TRUC'})
ON CREATE SET p.content = "Có hai trục đối xứng là hai đường chéo.",
              p.searchText = "   co hai truc doi xung la hai duong cheo. "
ON MATCH SET p.content = "Có hai trục đối xứng là hai đường chéo.",
             p.searchText = "   co hai truc doi xung la hai duong cheo. ";

MERGE (p:Property {id: 'P-VUONG-BON-TRUC'})
ON CREATE SET p.content = "Có bốn trục đối xứng: hai đường chéo và hai đường thẳng đi qua trung điểm các cặp cạnh đối.",
              p.searchText = "   co bon truc doi xung: hai duong cheo va hai duong thang di qua trung diem cac cap canh doi. "
ON MATCH SET p.content = "Có bốn trục đối xứng: hai đường chéo và hai đường thẳng đi qua trung điểm các cặp cạnh đối.",
             p.searchText = "   co bon truc doi xung: hai duong cheo va hai duong thang di qua trung diem cac cap canh doi. ";

MERGE (p:Property {id: 'P-VUONG-CHEO-CANH'})
ON CREATE SET p.content = "Độ dài đường chéo bằng độ dài cạnh nhân √2.",
              p.searchText = "   do dai duong cheo bang do dai canh nhan √2. "
ON MATCH SET p.content = "Độ dài đường chéo bằng độ dài cạnh nhân √2.",
             p.searchText = "   do dai duong cheo bang do dai canh nhan √2. ";

MERGE (p:Property {id: 'P-VUONG-NOI-NGOAI-TIEP'})
ON CREATE SET p.content = "Có đường tròn ngoại tiếp và đường tròn nội tiếp cùng tâm là giao điểm hai đường chéo.",
              p.searchText = "   co duong tron ngoai tiep va duong tron noi tiep cung tam la giao diem hai duong cheo. "
ON MATCH SET p.content = "Có đường tròn ngoại tiếp và đường tròn nội tiếp cùng tâm là giao điểm hai đường chéo.",
             p.searchText = "   co duong tron ngoai tiep va duong tron noi tiep cung tam la giao diem hai duong cheo. ";

MATCH (s:Shape {slug: 'hinh-binh-hanh'}), (p:Property {id: 'P-HBH-CANH-DOI'})
MERGE (s)-[:HAS_PROPERTY]->(p);

MATCH (s:Shape {slug: 'hinh-binh-hanh'}), (p:Property {id: 'P-HBH-CHEO-TRUNG-DIEM'})
MERGE (s)-[:HAS_PROPERTY]->(p);

MATCH (s:Shape {slug: 'hinh-binh-hanh'}), (p:Property {id: 'P-HBH-GOC-DOI'})
MERGE (s)-[:HAS_PROPERTY]->(p);

MATCH (s:Shape {slug: 'hinh-binh-hanh'}), (p:Property {id: 'P-HBH-TAM-DOI-XUNG'})
MERGE (s)-[:HAS_PROPERTY]->(p);

MATCH (s:Shape {slug: 'hinh-chu-nhat'}), (p:Property {id: 'P-HCN-BON-GOC-VUONG'})
MERGE (s)-[:HAS_PROPERTY]->(p);

MATCH (s:Shape {slug: 'hinh-chu-nhat'}), (p:Property {id: 'P-HCN-HAI-TRUC'})
MERGE (s)-[:HAS_PROPERTY]->(p);

MATCH (s:Shape {slug: 'hinh-dieu'}), (p:Property {id: 'P-DIEU-CANH-KE'})
MERGE (s)-[:HAS_PROPERTY]->(p);

MATCH (s:Shape {slug: 'hinh-dieu'}), (p:Property {id: 'P-DIEU-GOC-DOI'})
MERGE (s)-[:HAS_PROPERTY]->(p);

MATCH (s:Shape {slug: 'hinh-dieu'}), (p:Property {id: 'P-DIEU-TRUC-DOI-XUNG'})
MERGE (s)-[:HAS_PROPERTY]->(p);

MATCH (s:Shape {slug: 'hinh-dieu'}), (p:Property {id: 'P-DUONG-CHEO-VUONG-GOC'})
MERGE (s)-[:HAS_PROPERTY]->(p);

MATCH (s:Shape {slug: 'hinh-thang'}), (p:Property {id: 'P-HT-CAP-SONG-SONG'})
MERGE (s)-[:HAS_PROPERTY]->(p);

MATCH (s:Shape {slug: 'hinh-thang'}), (p:Property {id: 'P-HT-DUONG-TRUNG-BINH'})
MERGE (s)-[:HAS_PROPERTY]->(p);

MATCH (s:Shape {slug: 'hinh-thang'}), (p:Property {id: 'P-HT-GOC-KE-BEN'})
MERGE (s)-[:HAS_PROPERTY]->(p);

MATCH (s:Shape {slug: 'hinh-thang-can'}), (p:Property {id: 'P-HTC-CANH-BEN'})
MERGE (s)-[:HAS_PROPERTY]->(p);

MATCH (s:Shape {slug: 'hinh-thang-can'}), (p:Property {id: 'P-HTC-CHEO-BANG'})
MERGE (s)-[:HAS_PROPERTY]->(p);

MATCH (s:Shape {slug: 'hinh-thang-can'}), (p:Property {id: 'P-HTC-GOC-DAY'})
MERGE (s)-[:HAS_PROPERTY]->(p);

MATCH (s:Shape {slug: 'hinh-thang-can'}), (p:Property {id: 'P-HTC-NOI-TIEP'})
MERGE (s)-[:HAS_PROPERTY]->(p);

MATCH (s:Shape {slug: 'hinh-thoi'}), (p:Property {id: 'P-DUONG-CHEO-VUONG-GOC'})
MERGE (s)-[:HAS_PROPERTY]->(p);

MATCH (s:Shape {slug: 'hinh-thoi'}), (p:Property {id: 'P-THOI-BON-CANH'})
MERGE (s)-[:HAS_PROPERTY]->(p);

MATCH (s:Shape {slug: 'hinh-thoi'}), (p:Property {id: 'P-THOI-CHEO-PHAN-GIAC'})
MERGE (s)-[:HAS_PROPERTY]->(p);

MATCH (s:Shape {slug: 'hinh-thoi'}), (p:Property {id: 'P-THOI-HAI-TRUC'})
MERGE (s)-[:HAS_PROPERTY]->(p);

MATCH (s:Shape {slug: 'hinh-vuong'}), (p:Property {id: 'P-VUONG-BON-TRUC'})
MERGE (s)-[:HAS_PROPERTY]->(p);

MATCH (s:Shape {slug: 'hinh-vuong'}), (p:Property {id: 'P-VUONG-CHEO-CANH'})
MERGE (s)-[:HAS_PROPERTY]->(p);

MATCH (s:Shape {slug: 'hinh-vuong'}), (p:Property {id: 'P-VUONG-NOI-NGOAI-TIEP'})
MERGE (s)-[:HAS_PROPERTY]->(p);

MATCH (s:Shape {slug: 'tu-giac'}), (p:Property {id: 'P-TG-CANH-NHO-HON'})
MERGE (s)-[:HAS_PROPERTY]->(p);

MATCH (s:Shape {slug: 'tu-giac'}), (p:Property {id: 'P-TG-DINH-CANH-CHEO'})
MERGE (s)-[:HAS_PROPERTY]->(p);

MATCH (s:Shape {slug: 'tu-giac'}), (p:Property {id: 'P-TG-TONG-GOC'})
MERGE (s)-[:HAS_PROPERTY]->(p);


// --------------------------------------------------
// 5. ĐỊNH LÝ (THEOREMS)
// --------------------------------------------------

MERGE (t:Theorem {id: 'T-HBH-TINH-CHAT'})
ON CREATE SET t.title = "Tính chất của hình bình hành",
              t.content = "Trong hình bình hành: các cạnh đối bằng nhau, các góc đối bằng nhau, hai đường chéo cắt nhau tại trung điểm của mỗi đường.",
              t.searchText = " tinh chat cua hinh binh hanh  trong hinh binh hanh: cac canh doi bang nhau, cac goc doi bang nhau, hai duong cheo cat nhau tai trung diem cua moi duong. "
ON MATCH SET t.title = "Tính chất của hình bình hành",
             t.content = "Trong hình bình hành: các cạnh đối bằng nhau, các góc đối bằng nhau, hai đường chéo cắt nhau tại trung điểm của mỗi đường.",
             t.searchText = " tinh chat cua hinh binh hanh  trong hinh binh hanh: cac canh doi bang nhau, cac goc doi bang nhau, hai duong cheo cat nhau tai trung diem cua moi duong. "
WITH t
MATCH (s:Shape {slug: 'hinh-binh-hanh'})
MERGE (s)-[:HAS_THEOREM]->(t);

MERGE (t:Theorem {id: 'T-HCN-CHEO'})
ON CREATE SET t.title = "Hai đường chéo của hình chữ nhật",
              t.content = "Trong hình chữ nhật, hai đường chéo bằng nhau và cắt nhau tại trung điểm của mỗi đường.",
              t.searchText = " hai duong cheo cua hinh chu nhat  trong hinh chu nhat, hai duong cheo bang nhau va cat nhau tai trung diem cua moi duong. "
ON MATCH SET t.title = "Hai đường chéo của hình chữ nhật",
             t.content = "Trong hình chữ nhật, hai đường chéo bằng nhau và cắt nhau tại trung điểm của mỗi đường.",
             t.searchText = " hai duong cheo cua hinh chu nhat  trong hinh chu nhat, hai duong cheo bang nhau va cat nhau tai trung diem cua moi duong. "
WITH t
MATCH (s:Shape {slug: 'hinh-chu-nhat'})
MERGE (s)-[:HAS_THEOREM]->(t);

MERGE (t:Theorem {id: 'T-DIEU-CHEO'})
ON CREATE SET t.title = "Hai đường chéo của hình diều",
              t.content = "Trong hình diều, hai đường chéo vuông góc với nhau.",
              t.searchText = " hai duong cheo cua hinh dieu  trong hinh dieu, hai duong cheo vuong goc voi nhau. "
ON MATCH SET t.title = "Hai đường chéo của hình diều",
             t.content = "Trong hình diều, hai đường chéo vuông góc với nhau.",
             t.searchText = " hai duong cheo cua hinh dieu  trong hinh dieu, hai duong cheo vuong goc voi nhau. "
WITH t
MATCH (s:Shape {slug: 'hinh-dieu'})
MERGE (s)-[:HAS_THEOREM]->(t);

MERGE (t:Theorem {id: 'T-HT-DUONG-TRUNG-BINH'})
ON CREATE SET t.title = "Đường trung bình của hình thang",
              t.content = "Đường trung bình của hình thang (đoạn nối trung điểm hai cạnh bên) song song với hai đáy và có độ dài bằng nửa tổng hai đáy.",
              t.searchText = " duong trung binh cua hinh thang  duong trung binh cua hinh thang (doan noi trung diem hai canh ben) song song voi hai day va co do dai bang nua tong hai day. "
ON MATCH SET t.title = "Đường trung bình của hình thang",
             t.content = "Đường trung bình của hình thang (đoạn nối trung điểm hai cạnh bên) song song với hai đáy và có độ dài bằng nửa tổng hai đáy.",
             t.searchText = " duong trung binh cua hinh thang  duong trung binh cua hinh thang (doan noi trung diem hai canh ben) song song voi hai day va co do dai bang nua tong hai day. "
WITH t
MATCH (s:Shape {slug: 'hinh-thang'})
MERGE (s)-[:HAS_THEOREM]->(t);

MERGE (t:Theorem {id: 'T-HTC-CHEO'})
ON CREATE SET t.title = "Hai đường chéo của hình thang cân",
              t.content = "Trong hình thang cân, hai đường chéo bằng nhau.",
              t.searchText = " hai duong cheo cua hinh thang can  trong hinh thang can, hai duong cheo bang nhau. "
ON MATCH SET t.title = "Hai đường chéo của hình thang cân",
             t.content = "Trong hình thang cân, hai đường chéo bằng nhau.",
             t.searchText = " hai duong cheo cua hinh thang can  trong hinh thang can, hai duong cheo bang nhau. "
WITH t
MATCH (s:Shape {slug: 'hinh-thang-can'})
MERGE (s)-[:HAS_THEOREM]->(t);

MERGE (t:Theorem {id: 'T-THOI-CHEO'})
ON CREATE SET t.title = "Hai đường chéo của hình thoi",
              t.content = "Trong hình thoi, hai đường chéo vuông góc với nhau và là các đường phân giác của các góc của hình thoi.",
              t.searchText = " hai duong cheo cua hinh thoi  trong hinh thoi, hai duong cheo vuong goc voi nhau va la cac duong phan giac cua cac goc cua hinh thoi. "
ON MATCH SET t.title = "Hai đường chéo của hình thoi",
             t.content = "Trong hình thoi, hai đường chéo vuông góc với nhau và là các đường phân giác của các góc của hình thoi.",
             t.searchText = " hai duong cheo cua hinh thoi  trong hinh thoi, hai duong cheo vuong goc voi nhau va la cac duong phan giac cua cac goc cua hinh thoi. "
WITH t
MATCH (s:Shape {slug: 'hinh-thoi'})
MERGE (s)-[:HAS_THEOREM]->(t);

MERGE (t:Theorem {id: 'T-VUONG-CHEO'})
ON CREATE SET t.title = "Hai đường chéo của hình vuông",
              t.content = "Trong hình vuông, hai đường chéo bằng nhau, vuông góc với nhau, cắt nhau tại trung điểm của mỗi đường và là các đường phân giác của các góc.",
              t.searchText = " hai duong cheo cua hinh vuong  trong hinh vuong, hai duong cheo bang nhau, vuong goc voi nhau, cat nhau tai trung diem cua moi duong va la cac duong phan giac cua cac goc. "
ON MATCH SET t.title = "Hai đường chéo của hình vuông",
             t.content = "Trong hình vuông, hai đường chéo bằng nhau, vuông góc với nhau, cắt nhau tại trung điểm của mỗi đường và là các đường phân giác của các góc.",
             t.searchText = " hai duong cheo cua hinh vuong  trong hinh vuong, hai duong cheo bang nhau, vuong goc voi nhau, cat nhau tai trung diem cua moi duong va la cac duong phan giac cua cac goc. "
WITH t
MATCH (s:Shape {slug: 'hinh-vuong'})
MERGE (s)-[:HAS_THEOREM]->(t);

MERGE (t:Theorem {id: 'T-TG-TONG-GOC'})
ON CREATE SET t.title = "Tổng các góc của tứ giác",
              t.content = "Tổng bốn góc của một tứ giác bằng 360°. Chứng minh: kẻ một đường chéo, tứ giác được chia thành hai tam giác; mỗi tam giác có tổng ba góc bằng 180°, nên tổng bốn góc là 2 × 180° = 360°.",
              t.searchText = " tong cac goc cua tu giac  tong bon goc cua mot tu giac bang 360°. chung minh: ke mot duong cheo, tu giac duoc chia thanh hai tam giac; moi tam giac co tong ba goc bang 180°, nen tong bon goc la 2 × 180° = 360°. "
ON MATCH SET t.title = "Tổng các góc của tứ giác",
             t.content = "Tổng bốn góc của một tứ giác bằng 360°. Chứng minh: kẻ một đường chéo, tứ giác được chia thành hai tam giác; mỗi tam giác có tổng ba góc bằng 180°, nên tổng bốn góc là 2 × 180° = 360°.",
             t.searchText = " tong cac goc cua tu giac  tong bon goc cua mot tu giac bang 360°. chung minh: ke mot duong cheo, tu giac duoc chia thanh hai tam giac; moi tam giac co tong ba goc bang 180°, nen tong bon goc la 2 × 180° = 360°. "
WITH t
MATCH (s:Shape {slug: 'tu-giac'})
MERGE (s)-[:HAS_THEOREM]->(t);


// --------------------------------------------------
// 6. DẤU HIỆU NHẬN BIẾT (RECOGNITIONS)
// --------------------------------------------------

MERGE (r:Recognition {id: 'R-HBH-1'})
ON CREATE SET r.content = "Tứ giác có các cạnh đối song song là hình bình hành.",
              r.searchText = "   tu giac co cac canh doi song song la hinh binh hanh. "
ON MATCH SET r.content = "Tứ giác có các cạnh đối song song là hình bình hành.",
             r.searchText = "   tu giac co cac canh doi song song la hinh binh hanh. "
WITH r
MATCH (s:Shape {slug: 'hinh-binh-hanh'})
MERGE (s)-[:HAS_RECOGNITION]->(r);

MERGE (r:Recognition {id: 'R-HBH-2'})
ON CREATE SET r.content = "Tứ giác có các cạnh đối bằng nhau là hình bình hành.",
              r.searchText = "   tu giac co cac canh doi bang nhau la hinh binh hanh. "
ON MATCH SET r.content = "Tứ giác có các cạnh đối bằng nhau là hình bình hành.",
             r.searchText = "   tu giac co cac canh doi bang nhau la hinh binh hanh. "
WITH r
MATCH (s:Shape {slug: 'hinh-binh-hanh'})
MERGE (s)-[:HAS_RECOGNITION]->(r);

MERGE (r:Recognition {id: 'R-HBH-3'})
ON CREATE SET r.content = "Tứ giác có hai cạnh đối song song và bằng nhau là hình bình hành.",
              r.searchText = "   tu giac co hai canh doi song song va bang nhau la hinh binh hanh. "
ON MATCH SET r.content = "Tứ giác có hai cạnh đối song song và bằng nhau là hình bình hành.",
             r.searchText = "   tu giac co hai canh doi song song va bang nhau la hinh binh hanh. "
WITH r
MATCH (s:Shape {slug: 'hinh-binh-hanh'})
MERGE (s)-[:HAS_RECOGNITION]->(r);

MERGE (r:Recognition {id: 'R-HBH-4'})
ON CREATE SET r.content = "Tứ giác có các góc đối bằng nhau là hình bình hành.",
              r.searchText = "   tu giac co cac goc doi bang nhau la hinh binh hanh. "
ON MATCH SET r.content = "Tứ giác có các góc đối bằng nhau là hình bình hành.",
             r.searchText = "   tu giac co cac goc doi bang nhau la hinh binh hanh. "
WITH r
MATCH (s:Shape {slug: 'hinh-binh-hanh'})
MERGE (s)-[:HAS_RECOGNITION]->(r);

MERGE (r:Recognition {id: 'R-HBH-5'})
ON CREATE SET r.content = "Tứ giác có hai đường chéo cắt nhau tại trung điểm của mỗi đường là hình bình hành.",
              r.searchText = "   tu giac co hai duong cheo cat nhau tai trung diem cua moi duong la hinh binh hanh. "
ON MATCH SET r.content = "Tứ giác có hai đường chéo cắt nhau tại trung điểm của mỗi đường là hình bình hành.",
             r.searchText = "   tu giac co hai duong cheo cat nhau tai trung diem cua moi duong la hinh binh hanh. "
WITH r
MATCH (s:Shape {slug: 'hinh-binh-hanh'})
MERGE (s)-[:HAS_RECOGNITION]->(r);

MERGE (r:Recognition {id: 'R-HCN-1'})
ON CREATE SET r.content = "Tứ giác có ba góc vuông là hình chữ nhật.",
              r.searchText = "   tu giac co ba goc vuong la hinh chu nhat. "
ON MATCH SET r.content = "Tứ giác có ba góc vuông là hình chữ nhật.",
             r.searchText = "   tu giac co ba goc vuong la hinh chu nhat. "
WITH r
MATCH (s:Shape {slug: 'hinh-chu-nhat'})
MERGE (s)-[:HAS_RECOGNITION]->(r);

MERGE (r:Recognition {id: 'R-HCN-2'})
ON CREATE SET r.content = "Hình thang cân có một góc vuông là hình chữ nhật.",
              r.searchText = "   hinh thang can co mot goc vuong la hinh chu nhat. "
ON MATCH SET r.content = "Hình thang cân có một góc vuông là hình chữ nhật.",
             r.searchText = "   hinh thang can co mot goc vuong la hinh chu nhat. "
WITH r
MATCH (s:Shape {slug: 'hinh-chu-nhat'})
MERGE (s)-[:HAS_RECOGNITION]->(r);

MERGE (r:Recognition {id: 'R-HCN-3'})
ON CREATE SET r.content = "Hình bình hành có một góc vuông là hình chữ nhật.",
              r.searchText = "   hinh binh hanh co mot goc vuong la hinh chu nhat. "
ON MATCH SET r.content = "Hình bình hành có một góc vuông là hình chữ nhật.",
             r.searchText = "   hinh binh hanh co mot goc vuong la hinh chu nhat. "
WITH r
MATCH (s:Shape {slug: 'hinh-chu-nhat'})
MERGE (s)-[:HAS_RECOGNITION]->(r);

MERGE (r:Recognition {id: 'R-HCN-4'})
ON CREATE SET r.content = "Hình bình hành có hai đường chéo bằng nhau là hình chữ nhật.",
              r.searchText = "   hinh binh hanh co hai duong cheo bang nhau la hinh chu nhat. "
ON MATCH SET r.content = "Hình bình hành có hai đường chéo bằng nhau là hình chữ nhật.",
             r.searchText = "   hinh binh hanh co hai duong cheo bang nhau la hinh chu nhat. "
WITH r
MATCH (s:Shape {slug: 'hinh-chu-nhat'})
MERGE (s)-[:HAS_RECOGNITION]->(r);

MERGE (r:Recognition {id: 'R-DIEU-1'})
ON CREATE SET r.content = "Tứ giác có hai cặp cạnh kề bằng nhau là hình diều.",
              r.searchText = "   tu giac co hai cap canh ke bang nhau la hinh dieu. "
ON MATCH SET r.content = "Tứ giác có hai cặp cạnh kề bằng nhau là hình diều.",
             r.searchText = "   tu giac co hai cap canh ke bang nhau la hinh dieu. "
WITH r
MATCH (s:Shape {slug: 'hinh-dieu'})
MERGE (s)-[:HAS_RECOGNITION]->(r);

MERGE (r:Recognition {id: 'R-DIEU-2'})
ON CREATE SET r.content = "Tứ giác có một đường chéo là đường trung trực của đường chéo kia là hình diều.",
              r.searchText = "   tu giac co mot duong cheo la duong trung truc cua duong cheo kia la hinh dieu. "
ON MATCH SET r.content = "Tứ giác có một đường chéo là đường trung trực của đường chéo kia là hình diều.",
             r.searchText = "   tu giac co mot duong cheo la duong trung truc cua duong cheo kia la hinh dieu. "
WITH r
MATCH (s:Shape {slug: 'hinh-dieu'})
MERGE (s)-[:HAS_RECOGNITION]->(r);

MERGE (r:Recognition {id: 'R-HT-1'})
ON CREATE SET r.content = "Tứ giác có một cặp cạnh đối song song là hình thang.",
              r.searchText = "   tu giac co mot cap canh doi song song la hinh thang. "
ON MATCH SET r.content = "Tứ giác có một cặp cạnh đối song song là hình thang.",
             r.searchText = "   tu giac co mot cap canh doi song song la hinh thang. "
WITH r
MATCH (s:Shape {slug: 'hinh-thang'})
MERGE (s)-[:HAS_RECOGNITION]->(r);

MERGE (r:Recognition {id: 'R-HTC-1'})
ON CREATE SET r.content = "Hình thang có hai góc kề một đáy bằng nhau là hình thang cân.",
              r.searchText = "   hinh thang co hai goc ke mot day bang nhau la hinh thang can. "
ON MATCH SET r.content = "Hình thang có hai góc kề một đáy bằng nhau là hình thang cân.",
             r.searchText = "   hinh thang co hai goc ke mot day bang nhau la hinh thang can. "
WITH r
MATCH (s:Shape {slug: 'hinh-thang-can'})
MERGE (s)-[:HAS_RECOGNITION]->(r);

MERGE (r:Recognition {id: 'R-HTC-2'})
ON CREATE SET r.content = "Hình thang có hai đường chéo bằng nhau là hình thang cân.",
              r.searchText = "   hinh thang co hai duong cheo bang nhau la hinh thang can. "
ON MATCH SET r.content = "Hình thang có hai đường chéo bằng nhau là hình thang cân.",
             r.searchText = "   hinh thang co hai duong cheo bang nhau la hinh thang can. "
WITH r
MATCH (s:Shape {slug: 'hinh-thang-can'})
MERGE (s)-[:HAS_RECOGNITION]->(r);

MERGE (r:Recognition {id: 'R-THOI-1'})
ON CREATE SET r.content = "Tứ giác có bốn cạnh bằng nhau là hình thoi.",
              r.searchText = "   tu giac co bon canh bang nhau la hinh thoi. "
ON MATCH SET r.content = "Tứ giác có bốn cạnh bằng nhau là hình thoi.",
             r.searchText = "   tu giac co bon canh bang nhau la hinh thoi. "
WITH r
MATCH (s:Shape {slug: 'hinh-thoi'})
MERGE (s)-[:HAS_RECOGNITION]->(r);

MERGE (r:Recognition {id: 'R-THOI-2'})
ON CREATE SET r.content = "Hình bình hành có hai cạnh kề bằng nhau là hình thoi.",
              r.searchText = "   hinh binh hanh co hai canh ke bang nhau la hinh thoi. "
ON MATCH SET r.content = "Hình bình hành có hai cạnh kề bằng nhau là hình thoi.",
             r.searchText = "   hinh binh hanh co hai canh ke bang nhau la hinh thoi. "
WITH r
MATCH (s:Shape {slug: 'hinh-thoi'})
MERGE (s)-[:HAS_RECOGNITION]->(r);

MERGE (r:Recognition {id: 'R-THOI-3'})
ON CREATE SET r.content = "Hình bình hành có hai đường chéo vuông góc với nhau là hình thoi.",
              r.searchText = "   hinh binh hanh co hai duong cheo vuong goc voi nhau la hinh thoi. "
ON MATCH SET r.content = "Hình bình hành có hai đường chéo vuông góc với nhau là hình thoi.",
             r.searchText = "   hinh binh hanh co hai duong cheo vuong goc voi nhau la hinh thoi. "
WITH r
MATCH (s:Shape {slug: 'hinh-thoi'})
MERGE (s)-[:HAS_RECOGNITION]->(r);

MERGE (r:Recognition {id: 'R-THOI-4'})
ON CREATE SET r.content = "Hình bình hành có một đường chéo là đường phân giác của một góc là hình thoi.",
              r.searchText = "   hinh binh hanh co mot duong cheo la duong phan giac cua mot goc la hinh thoi. "
ON MATCH SET r.content = "Hình bình hành có một đường chéo là đường phân giác của một góc là hình thoi.",
             r.searchText = "   hinh binh hanh co mot duong cheo la duong phan giac cua mot goc la hinh thoi. "
WITH r
MATCH (s:Shape {slug: 'hinh-thoi'})
MERGE (s)-[:HAS_RECOGNITION]->(r);

MERGE (r:Recognition {id: 'R-VUONG-1'})
ON CREATE SET r.content = "Hình chữ nhật có hai cạnh kề bằng nhau là hình vuông.",
              r.searchText = "   hinh chu nhat co hai canh ke bang nhau la hinh vuong. "
ON MATCH SET r.content = "Hình chữ nhật có hai cạnh kề bằng nhau là hình vuông.",
             r.searchText = "   hinh chu nhat co hai canh ke bang nhau la hinh vuong. "
WITH r
MATCH (s:Shape {slug: 'hinh-vuong'})
MERGE (s)-[:HAS_RECOGNITION]->(r);

MERGE (r:Recognition {id: 'R-VUONG-2'})
ON CREATE SET r.content = "Hình chữ nhật có hai đường chéo vuông góc với nhau là hình vuông.",
              r.searchText = "   hinh chu nhat co hai duong cheo vuong goc voi nhau la hinh vuong. "
ON MATCH SET r.content = "Hình chữ nhật có hai đường chéo vuông góc với nhau là hình vuông.",
             r.searchText = "   hinh chu nhat co hai duong cheo vuong goc voi nhau la hinh vuong. "
WITH r
MATCH (s:Shape {slug: 'hinh-vuong'})
MERGE (s)-[:HAS_RECOGNITION]->(r);

MERGE (r:Recognition {id: 'R-VUONG-3'})
ON CREATE SET r.content = "Hình chữ nhật có một đường chéo là đường phân giác của một góc là hình vuông.",
              r.searchText = "   hinh chu nhat co mot duong cheo la duong phan giac cua mot goc la hinh vuong. "
ON MATCH SET r.content = "Hình chữ nhật có một đường chéo là đường phân giác của một góc là hình vuông.",
             r.searchText = "   hinh chu nhat co mot duong cheo la duong phan giac cua mot goc la hinh vuong. "
WITH r
MATCH (s:Shape {slug: 'hinh-vuong'})
MERGE (s)-[:HAS_RECOGNITION]->(r);

MERGE (r:Recognition {id: 'R-VUONG-4'})
ON CREATE SET r.content = "Hình thoi có một góc vuông là hình vuông.",
              r.searchText = "   hinh thoi co mot goc vuong la hinh vuong. "
ON MATCH SET r.content = "Hình thoi có một góc vuông là hình vuông.",
             r.searchText = "   hinh thoi co mot goc vuong la hinh vuong. "
WITH r
MATCH (s:Shape {slug: 'hinh-vuong'})
MERGE (s)-[:HAS_RECOGNITION]->(r);

MERGE (r:Recognition {id: 'R-VUONG-5'})
ON CREATE SET r.content = "Hình thoi có hai đường chéo bằng nhau là hình vuông.",
              r.searchText = "   hinh thoi co hai duong cheo bang nhau la hinh vuong. "
ON MATCH SET r.content = "Hình thoi có hai đường chéo bằng nhau là hình vuông.",
             r.searchText = "   hinh thoi co hai duong cheo bang nhau la hinh vuong. "
WITH r
MATCH (s:Shape {slug: 'hinh-vuong'})
MERGE (s)-[:HAS_RECOGNITION]->(r);

MERGE (r:Recognition {id: 'R-TG-1'})
ON CREATE SET r.content = "Nối bốn điểm A, B, C, D (không có ba điểm liên tiếp nào thẳng hàng) theo thứ tự thành đường gấp khúc khép kín không tự cắt thì được một tứ giác.",
              r.searchText = "   noi bon diem a, b, c, d (khong co ba diem lien tiep nao thang hang) theo thu tu thanh duong gap khuc khep kin khong tu cat thi duoc mot tu giac. "
ON MATCH SET r.content = "Nối bốn điểm A, B, C, D (không có ba điểm liên tiếp nào thẳng hàng) theo thứ tự thành đường gấp khúc khép kín không tự cắt thì được một tứ giác.",
             r.searchText = "   noi bon diem a, b, c, d (khong co ba diem lien tiep nao thang hang) theo thu tu thanh duong gap khuc khep kin khong tu cat thi duoc mot tu giac. "
WITH r
MATCH (s:Shape {slug: 'tu-giac'})
MERGE (s)-[:HAS_RECOGNITION]->(r);


// --------------------------------------------------
// 7. CÔNG THỨC (FORMULAS - KATEX)
// --------------------------------------------------

MERGE (f:Formula {id: 'F-HBH-CHU-VI'})
ON CREATE SET f.name = "Chu vi hình bình hành",
              f.expression = "P=2(a+b)",
              f.note = "a, b là độ dài hai cạnh kề.",
              f.searchText = "chu vi hinh binh hanh    a, b la do dai hai canh ke."
ON MATCH SET f.name = "Chu vi hình bình hành",
             f.expression = "P=2(a+b)",
             f.note = "a, b là độ dài hai cạnh kề.",
             f.searchText = "chu vi hinh binh hanh    a, b la do dai hai canh ke."
WITH f
MATCH (s:Shape {slug: 'hinh-binh-hanh'})
MERGE (s)-[:HAS_FORMULA]->(f);

MERGE (f:Formula {id: 'F-HBH-DIEN-TICH'})
ON CREATE SET f.name = "Diện tích hình bình hành",
              f.expression = "S=a\\cdot h",
              f.note = "a là độ dài một cạnh; h là chiều cao tương ứng với cạnh đó.",
              f.searchText = "dien tich hinh binh hanh    a la do dai mot canh; h la chieu cao tuong ung voi canh do."
ON MATCH SET f.name = "Diện tích hình bình hành",
             f.expression = "S=a\\cdot h",
             f.note = "a là độ dài một cạnh; h là chiều cao tương ứng với cạnh đó.",
             f.searchText = "dien tich hinh binh hanh    a la do dai mot canh; h la chieu cao tuong ung voi canh do."
WITH f
MATCH (s:Shape {slug: 'hinh-binh-hanh'})
MERGE (s)-[:HAS_FORMULA]->(f);

MERGE (f:Formula {id: 'F-HCN-CHEO'})
ON CREATE SET f.name = "Độ dài đường chéo hình chữ nhật",
              f.expression = "d=\\sqrt{a^2+b^2}",
              f.note = "Áp dụng định lý Pythagore cho tam giác vuông tạo bởi hai cạnh kề và đường chéo.",
              f.searchText = "do dai duong cheo hinh chu nhat    ap dung dinh ly pythagore cho tam giac vuong tao boi hai canh ke va duong cheo."
ON MATCH SET f.name = "Độ dài đường chéo hình chữ nhật",
             f.expression = "d=\\sqrt{a^2+b^2}",
             f.note = "Áp dụng định lý Pythagore cho tam giác vuông tạo bởi hai cạnh kề và đường chéo.",
             f.searchText = "do dai duong cheo hinh chu nhat    ap dung dinh ly pythagore cho tam giac vuong tao boi hai canh ke va duong cheo."
WITH f
MATCH (s:Shape {slug: 'hinh-chu-nhat'})
MERGE (s)-[:HAS_FORMULA]->(f);

MERGE (f:Formula {id: 'F-HCN-CHU-VI'})
ON CREATE SET f.name = "Chu vi hình chữ nhật",
              f.expression = "P=2(a+b)",
              f.note = "a, b là chiều dài và chiều rộng.",
              f.searchText = "chu vi hinh chu nhat    a, b la chieu dai va chieu rong."
ON MATCH SET f.name = "Chu vi hình chữ nhật",
             f.expression = "P=2(a+b)",
             f.note = "a, b là chiều dài và chiều rộng.",
             f.searchText = "chu vi hinh chu nhat    a, b la chieu dai va chieu rong."
WITH f
MATCH (s:Shape {slug: 'hinh-chu-nhat'})
MERGE (s)-[:HAS_FORMULA]->(f);

MERGE (f:Formula {id: 'F-HCN-DIEN-TICH'})
ON CREATE SET f.name = "Diện tích hình chữ nhật",
              f.expression = "S=a\\cdot b",
              f.note = "a, b là chiều dài và chiều rộng.",
              f.searchText = "dien tich hinh chu nhat    a, b la chieu dai va chieu rong."
ON MATCH SET f.name = "Diện tích hình chữ nhật",
             f.expression = "S=a\\cdot b",
             f.note = "a, b là chiều dài và chiều rộng.",
             f.searchText = "dien tich hinh chu nhat    a, b la chieu dai va chieu rong."
WITH f
MATCH (s:Shape {slug: 'hinh-chu-nhat'})
MERGE (s)-[:HAS_FORMULA]->(f);

MERGE (f:Formula {id: 'F-S-HAI-CHEO'})
ON CREATE SET f.name = "Diện tích theo hai đường chéo",
              f.expression = "S=\\dfrac{d_1\\cdot d_2}{2}",
              f.note = "d₁, d₂ là độ dài hai đường chéo vuông góc.",
              f.searchText = "dien tich theo hai duong cheo    d₁, d₂ la do dai hai duong cheo vuong goc."
ON MATCH SET f.name = "Diện tích theo hai đường chéo",
             f.expression = "S=\\dfrac{d_1\\cdot d_2}{2}",
             f.note = "d₁, d₂ là độ dài hai đường chéo vuông góc.",
             f.searchText = "dien tich theo hai duong cheo    d₁, d₂ la do dai hai duong cheo vuong goc."
WITH f
MATCH (s:Shape {slug: 'hinh-dieu'})
MERGE (s)-[:HAS_FORMULA]->(f);

MERGE (f:Formula {id: 'F-HT-DIEN-TICH'})
ON CREATE SET f.name = "Diện tích hình thang",
              f.expression = "S=\\dfrac{(a+b)\\cdot h}{2}",
              f.note = "a, b là độ dài hai đáy; h là chiều cao.",
              f.searchText = "dien tich hinh thang    a, b la do dai hai day; h la chieu cao."
ON MATCH SET f.name = "Diện tích hình thang",
             f.expression = "S=\\dfrac{(a+b)\\cdot h}{2}",
             f.note = "a, b là độ dài hai đáy; h là chiều cao.",
             f.searchText = "dien tich hinh thang    a, b la do dai hai day; h la chieu cao."
WITH f
MATCH (s:Shape {slug: 'hinh-thang'})
MERGE (s)-[:HAS_FORMULA]->(f);

MERGE (f:Formula {id: 'F-HT-DUONG-TRUNG-BINH'})
ON CREATE SET f.name = "Đường trung bình hình thang",
              f.expression = "m=\\dfrac{a+b}{2}",
              f.note = "a, b là độ dài hai đáy.",
              f.searchText = "duong trung binh hinh thang    a, b la do dai hai day."
ON MATCH SET f.name = "Đường trung bình hình thang",
             f.expression = "m=\\dfrac{a+b}{2}",
             f.note = "a, b là độ dài hai đáy.",
             f.searchText = "duong trung binh hinh thang    a, b la do dai hai day."
WITH f
MATCH (s:Shape {slug: 'hinh-thang'})
MERGE (s)-[:HAS_FORMULA]->(f);

MERGE (f:Formula {id: 'F-HT-DIEN-TICH'})
ON CREATE SET f.name = "Diện tích hình thang",
              f.expression = "S=\\dfrac{(a+b)\\cdot h}{2}",
              f.note = "a, b là độ dài hai đáy; h là chiều cao.",
              f.searchText = "dien tich hinh thang    a, b la do dai hai day; h la chieu cao."
ON MATCH SET f.name = "Diện tích hình thang",
             f.expression = "S=\\dfrac{(a+b)\\cdot h}{2}",
             f.note = "a, b là độ dài hai đáy; h là chiều cao.",
             f.searchText = "dien tich hinh thang    a, b la do dai hai day; h la chieu cao."
WITH f
MATCH (s:Shape {slug: 'hinh-thang-can'})
MERGE (s)-[:HAS_FORMULA]->(f);

MERGE (f:Formula {id: 'F-S-HAI-CHEO'})
ON CREATE SET f.name = "Diện tích theo hai đường chéo",
              f.expression = "S=\\dfrac{d_1\\cdot d_2}{2}",
              f.note = "d₁, d₂ là độ dài hai đường chéo vuông góc.",
              f.searchText = "dien tich theo hai duong cheo    d₁, d₂ la do dai hai duong cheo vuong goc."
ON MATCH SET f.name = "Diện tích theo hai đường chéo",
             f.expression = "S=\\dfrac{d_1\\cdot d_2}{2}",
             f.note = "d₁, d₂ là độ dài hai đường chéo vuông góc.",
             f.searchText = "dien tich theo hai duong cheo    d₁, d₂ la do dai hai duong cheo vuong goc."
WITH f
MATCH (s:Shape {slug: 'hinh-thoi'})
MERGE (s)-[:HAS_FORMULA]->(f);

MERGE (f:Formula {id: 'F-THOI-CHU-VI'})
ON CREATE SET f.name = "Chu vi hình thoi",
              f.expression = "P=4a",
              f.note = "a là độ dài một cạnh.",
              f.searchText = "chu vi hinh thoi    a la do dai mot canh."
ON MATCH SET f.name = "Chu vi hình thoi",
             f.expression = "P=4a",
             f.note = "a là độ dài một cạnh.",
             f.searchText = "chu vi hinh thoi    a la do dai mot canh."
WITH f
MATCH (s:Shape {slug: 'hinh-thoi'})
MERGE (s)-[:HAS_FORMULA]->(f);

MERGE (f:Formula {id: 'F-VUONG-CHEO'})
ON CREATE SET f.name = "Độ dài đường chéo hình vuông",
              f.expression = "d=a\\sqrt{2}",
              f.note = "a là độ dài một cạnh.",
              f.searchText = "do dai duong cheo hinh vuong    a la do dai mot canh."
ON MATCH SET f.name = "Độ dài đường chéo hình vuông",
             f.expression = "d=a\\sqrt{2}",
             f.note = "a là độ dài một cạnh.",
             f.searchText = "do dai duong cheo hinh vuong    a la do dai mot canh."
WITH f
MATCH (s:Shape {slug: 'hinh-vuong'})
MERGE (s)-[:HAS_FORMULA]->(f);

MERGE (f:Formula {id: 'F-VUONG-CHU-VI'})
ON CREATE SET f.name = "Chu vi hình vuông",
              f.expression = "P=4a",
              f.note = "a là độ dài một cạnh.",
              f.searchText = "chu vi hinh vuong    a la do dai mot canh."
ON MATCH SET f.name = "Chu vi hình vuông",
             f.expression = "P=4a",
             f.note = "a là độ dài một cạnh.",
             f.searchText = "chu vi hinh vuong    a la do dai mot canh."
WITH f
MATCH (s:Shape {slug: 'hinh-vuong'})
MERGE (s)-[:HAS_FORMULA]->(f);

MERGE (f:Formula {id: 'F-VUONG-DIEN-TICH'})
ON CREATE SET f.name = "Diện tích hình vuông",
              f.expression = "S=a^2",
              f.note = "a là độ dài một cạnh.",
              f.searchText = "dien tich hinh vuong    a la do dai mot canh."
ON MATCH SET f.name = "Diện tích hình vuông",
             f.expression = "S=a^2",
             f.note = "a là độ dài một cạnh.",
             f.searchText = "dien tich hinh vuong    a la do dai mot canh."
WITH f
MATCH (s:Shape {slug: 'hinh-vuong'})
MERGE (s)-[:HAS_FORMULA]->(f);

MERGE (f:Formula {id: 'F-TG-TONG-GOC'})
ON CREATE SET f.name = "Tổng bốn góc của tứ giác",
              f.expression = "\\widehat{A}+\\widehat{B}+\\widehat{C}+\\widehat{D}=360^\\circ",
              f.note = "Áp dụng cho mọi tứ giác ABCD.",
              f.searchText = "tong bon goc cua tu giac    ap dung cho moi tu giac abcd."
ON MATCH SET f.name = "Tổng bốn góc của tứ giác",
             f.expression = "\\widehat{A}+\\widehat{B}+\\widehat{C}+\\widehat{D}=360^\\circ",
             f.note = "Áp dụng cho mọi tứ giác ABCD.",
             f.searchText = "tong bon goc cua tu giac    ap dung cho moi tu giac abcd."
WITH f
MATCH (s:Shape {slug: 'tu-giac'})
MERGE (s)-[:HAS_FORMULA]->(f);


// --------------------------------------------------
// 8. VÍ DỤ MINH HỌA (EXAMPLES)
// --------------------------------------------------

MERGE (e:Example {id: 'E-HBH-1'})
ON CREATE SET e.title = "Tính các góc của hình bình hành",
              e.content = "Hình bình hành ABCD có ∠A = 65°. Tính ∠B, ∠C, ∠D.",
              e.solution = "Hai góc đối bằng nhau nên ∠C = ∠A = 65°. Hai góc kề một cạnh bù nhau nên ∠B = 180° − 65° = 115°, và ∠D = ∠B = 115°."
ON MATCH SET e.title = "Tính các góc của hình bình hành",
             e.content = "Hình bình hành ABCD có ∠A = 65°. Tính ∠B, ∠C, ∠D.",
             e.solution = "Hai góc đối bằng nhau nên ∠C = ∠A = 65°. Hai góc kề một cạnh bù nhau nên ∠B = 180° − 65° = 115°, và ∠D = ∠B = 115°."
WITH e
MATCH (s:Shape {slug: 'hinh-binh-hanh'})
MERGE (s)-[:HAS_EXAMPLE]->(e);

MERGE (e:Example {id: 'E-HCN-1'})
ON CREATE SET e.title = "Đường chéo và diện tích hình chữ nhật",
              e.content = "Hình chữ nhật có hai cạnh 6 cm và 8 cm. Tính độ dài đường chéo và diện tích.",
              e.solution = "Đường chéo d = √(6² + 8²) = √100 = 10 cm. Diện tích S = 6 · 8 = 48 cm²."
ON MATCH SET e.title = "Đường chéo và diện tích hình chữ nhật",
             e.content = "Hình chữ nhật có hai cạnh 6 cm và 8 cm. Tính độ dài đường chéo và diện tích.",
             e.solution = "Đường chéo d = √(6² + 8²) = √100 = 10 cm. Diện tích S = 6 · 8 = 48 cm²."
WITH e
MATCH (s:Shape {slug: 'hinh-chu-nhat'})
MERGE (s)-[:HAS_EXAMPLE]->(e);

MERGE (e:Example {id: 'E-DIEU-1'})
ON CREATE SET e.title = "Diện tích hình diều",
              e.content = "Hình diều ABCD có hai đường chéo AC = 10 cm và BD = 6 cm. Tính diện tích.",
              e.solution = "Hai đường chéo vuông góc nên S = 10 · 6 / 2 = 30 cm²."
ON MATCH SET e.title = "Diện tích hình diều",
             e.content = "Hình diều ABCD có hai đường chéo AC = 10 cm và BD = 6 cm. Tính diện tích.",
             e.solution = "Hai đường chéo vuông góc nên S = 10 · 6 / 2 = 30 cm²."
WITH e
MATCH (s:Shape {slug: 'hinh-dieu'})
MERGE (s)-[:HAS_EXAMPLE]->(e);

MERGE (e:Example {id: 'E-HT-1'})
ON CREATE SET e.title = "Tính diện tích hình thang",
              e.content = "Hình thang ABCD (AB ∥ CD) có AB = 6 cm, CD = 10 cm, chiều cao 4 cm. Tính diện tích.",
              e.solution = "S = (6 + 10) · 4 / 2 = 32 cm²."
ON MATCH SET e.title = "Tính diện tích hình thang",
             e.content = "Hình thang ABCD (AB ∥ CD) có AB = 6 cm, CD = 10 cm, chiều cao 4 cm. Tính diện tích.",
             e.solution = "S = (6 + 10) · 4 / 2 = 32 cm²."
WITH e
MATCH (s:Shape {slug: 'hinh-thang'})
MERGE (s)-[:HAS_EXAMPLE]->(e);

MERGE (e:Example {id: 'E-HTC-1'})
ON CREATE SET e.title = "Tính các góc của hình thang cân",
              e.content = "Hình thang cân ABCD (AB ∥ CD) có ∠A = 70°. Tính ∠B, ∠C, ∠D.",
              e.solution = "Hai góc kề đáy AB bằng nhau nên ∠B = ∠A = 70°. Vì AB ∥ CD nên ∠A + ∠D = 180°, suy ra ∠D = 110°. Hai góc kề đáy CD bằng nhau nên ∠C = ∠D = 110°."
ON MATCH SET e.title = "Tính các góc của hình thang cân",
             e.content = "Hình thang cân ABCD (AB ∥ CD) có ∠A = 70°. Tính ∠B, ∠C, ∠D.",
             e.solution = "Hai góc kề đáy AB bằng nhau nên ∠B = ∠A = 70°. Vì AB ∥ CD nên ∠A + ∠D = 180°, suy ra ∠D = 110°. Hai góc kề đáy CD bằng nhau nên ∠C = ∠D = 110°."
WITH e
MATCH (s:Shape {slug: 'hinh-thang-can'})
MERGE (s)-[:HAS_EXAMPLE]->(e);

MERGE (e:Example {id: 'E-THOI-1'})
ON CREATE SET e.title = "Cạnh và diện tích hình thoi",
              e.content = "Hình thoi có hai đường chéo dài 6 cm và 8 cm. Tính độ dài cạnh và diện tích.",
              e.solution = "Hai đường chéo vuông góc và cắt nhau tại trung điểm, nên cạnh là cạnh huyền của tam giác vuông có hai cạnh góc vuông 3 cm và 4 cm: cạnh = √(3² + 4²) = 5 cm. Diện tích S = 6 · 8 / 2 = 24 cm²."
ON MATCH SET e.title = "Cạnh và diện tích hình thoi",
             e.content = "Hình thoi có hai đường chéo dài 6 cm và 8 cm. Tính độ dài cạnh và diện tích.",
             e.solution = "Hai đường chéo vuông góc và cắt nhau tại trung điểm, nên cạnh là cạnh huyền của tam giác vuông có hai cạnh góc vuông 3 cm và 4 cm: cạnh = √(3² + 4²) = 5 cm. Diện tích S = 6 · 8 / 2 = 24 cm²."
WITH e
MATCH (s:Shape {slug: 'hinh-thoi'})
MERGE (s)-[:HAS_EXAMPLE]->(e);

MERGE (e:Example {id: 'E-VUONG-1'})
ON CREATE SET e.title = "Đường chéo, chu vi, diện tích hình vuông",
              e.content = "Hình vuông có cạnh 5 cm. Tính độ dài đường chéo, chu vi và diện tích.",
              e.solution = "Đường chéo d = 5√2 ≈ 7,07 cm. Chu vi P = 4 · 5 = 20 cm. Diện tích S = 5² = 25 cm²."
ON MATCH SET e.title = "Đường chéo, chu vi, diện tích hình vuông",
             e.content = "Hình vuông có cạnh 5 cm. Tính độ dài đường chéo, chu vi và diện tích.",
             e.solution = "Đường chéo d = 5√2 ≈ 7,07 cm. Chu vi P = 4 · 5 = 20 cm. Diện tích S = 5² = 25 cm²."
WITH e
MATCH (s:Shape {slug: 'hinh-vuong'})
MERGE (s)-[:HAS_EXAMPLE]->(e);

MERGE (e:Example {id: 'E-TG-1'})
ON CREATE SET e.title = "Tìm góc còn lại của tứ giác",
              e.content = "Tứ giác ABCD có ∠A = 80°, ∠B = 100°, ∠C = 70°. Tính ∠D.",
              e.solution = "Tổng bốn góc của tứ giác bằng 360°. ∠D = 360° − (80° + 100° + 70°) = 360° − 250° = 110°."
ON MATCH SET e.title = "Tìm góc còn lại của tứ giác",
             e.content = "Tứ giác ABCD có ∠A = 80°, ∠B = 100°, ∠C = 70°. Tính ∠D.",
             e.solution = "Tổng bốn góc của tứ giác bằng 360°. ∠D = 360° − (80° + 100° + 70°) = 360° − 250° = 110°."
WITH e
MATCH (s:Shape {slug: 'tu-giac'})
MERGE (s)-[:HAS_EXAMPLE]->(e);


// --------------------------------------------------
// 9. CÂU HỎI VÀ ĐÁP ÁN (40 CÂU HỎI, 160 PHƯƠNG ÁN)
// --------------------------------------------------

MERGE (q:Question {id: 'Q-DIEU-01'})
ON CREATE SET q.content = "Theo định nghĩa của bài học, hình diều là tứ giác có:",
              q.type = "THEORY",
              q.difficulty = 1,
              q.explanation = "Định nghĩa (nhóm chọn): hình diều là tứ giác có hai cặp cạnh kề bằng nhau."
ON MATCH SET q.content = "Theo định nghĩa của bài học, hình diều là tứ giác có:",
             q.type = "THEORY",
             q.difficulty = 1,
             q.explanation = "Định nghĩa (nhóm chọn): hình diều là tứ giác có hai cặp cạnh kề bằng nhau."
WITH q
MATCH (s:Shape {slug: 'hinh-dieu'})
MERGE (s)-[:HAS_QUESTION]->(q);

MERGE (o:AnswerOption {id: 'Q-DIEU-01-1'})
ON CREATE SET o.content = "Hai cặp cạnh đối bằng nhau",
              o.isCorrect = false
ON MATCH SET o.content = "Hai cặp cạnh đối bằng nhau",
             o.isCorrect = false
WITH o
MATCH (q:Question {id: 'Q-DIEU-01'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (o:AnswerOption {id: 'Q-DIEU-01-2'})
ON CREATE SET o.content = "Hai cặp cạnh kề bằng nhau",
              o.isCorrect = true
ON MATCH SET o.content = "Hai cặp cạnh kề bằng nhau",
             o.isCorrect = true
WITH o
MATCH (q:Question {id: 'Q-DIEU-01'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (o:AnswerOption {id: 'Q-DIEU-01-3'})
ON CREATE SET o.content = "Bốn cạnh bằng nhau và một góc vuông",
              o.isCorrect = false
ON MATCH SET o.content = "Bốn cạnh bằng nhau và một góc vuông",
             o.isCorrect = false
WITH o
MATCH (q:Question {id: 'Q-DIEU-01'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (o:AnswerOption {id: 'Q-DIEU-01-4'})
ON CREATE SET o.content = "Hai cạnh đối song song",
              o.isCorrect = false
ON MATCH SET o.content = "Hai cạnh đối song song",
             o.isCorrect = false
WITH o
MATCH (q:Question {id: 'Q-DIEU-01'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (q:Question {id: 'Q-DIEU-02'})
ON CREATE SET q.content = "Hình diều ABCD có AB = AD và CB = CD. Hai đường chéo AC và BD:",
              q.type = "THEORY",
              q.difficulty = 2,
              q.explanation = "A và C cùng cách đều hai đầu B, D nên AC là đường trung trực của BD. Vì vậy AC vuông góc với BD. Hai đường chéo của hình diều nói chung không bằng nhau và không chia đôi nhau."
ON MATCH SET q.content = "Hình diều ABCD có AB = AD và CB = CD. Hai đường chéo AC và BD:",
             q.type = "THEORY",
             q.difficulty = 2,
             q.explanation = "A và C cùng cách đều hai đầu B, D nên AC là đường trung trực của BD. Vì vậy AC vuông góc với BD. Hai đường chéo của hình diều nói chung không bằng nhau và không chia đôi nhau."
WITH q
MATCH (s:Shape {slug: 'hinh-dieu'})
MERGE (s)-[:HAS_QUESTION]->(q);

MERGE (o:AnswerOption {id: 'Q-DIEU-02-1'})
ON CREATE SET o.content = "Song song với nhau",
              o.isCorrect = false
ON MATCH SET o.content = "Song song với nhau",
             o.isCorrect = false
WITH o
MATCH (q:Question {id: 'Q-DIEU-02'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (o:AnswerOption {id: 'Q-DIEU-02-2'})
ON CREATE SET o.content = "Bằng nhau",
              o.isCorrect = false
ON MATCH SET o.content = "Bằng nhau",
             o.isCorrect = false
WITH o
MATCH (q:Question {id: 'Q-DIEU-02'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (o:AnswerOption {id: 'Q-DIEU-02-3'})
ON CREATE SET o.content = "Vuông góc với nhau",
              o.isCorrect = true
ON MATCH SET o.content = "Vuông góc với nhau",
             o.isCorrect = true
WITH o
MATCH (q:Question {id: 'Q-DIEU-02'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (o:AnswerOption {id: 'Q-DIEU-02-4'})
ON CREATE SET o.content = "Cắt nhau tại trung điểm của mỗi đường",
              o.isCorrect = false
ON MATCH SET o.content = "Cắt nhau tại trung điểm của mỗi đường",
             o.isCorrect = false
WITH o
MATCH (q:Question {id: 'Q-DIEU-02'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (q:Question {id: 'Q-DIEU-03'})
ON CREATE SET q.content = "Hình diều có hai đường chéo dài 12 cm và 9 cm. Diện tích hình diều là:",
              q.type = "CALCULATION",
              q.difficulty = 1,
              q.explanation = "Hai đường chéo vuông góc nên S = d₁ · d₂ / 2 = 12 · 9 / 2 = 54 cm²."
ON MATCH SET q.content = "Hình diều có hai đường chéo dài 12 cm và 9 cm. Diện tích hình diều là:",
             q.type = "CALCULATION",
             q.difficulty = 1,
             q.explanation = "Hai đường chéo vuông góc nên S = d₁ · d₂ / 2 = 12 · 9 / 2 = 54 cm²."
WITH q
MATCH (s:Shape {slug: 'hinh-dieu'})
MERGE (s)-[:HAS_QUESTION]->(q);

MERGE (o:AnswerOption {id: 'Q-DIEU-03-1'})
ON CREATE SET o.content = "21 cm²",
              o.isCorrect = false
ON MATCH SET o.content = "21 cm²",
             o.isCorrect = false
WITH o
MATCH (q:Question {id: 'Q-DIEU-03'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (o:AnswerOption {id: 'Q-DIEU-03-2'})
ON CREATE SET o.content = "54 cm²",
              o.isCorrect = true
ON MATCH SET o.content = "54 cm²",
             o.isCorrect = true
WITH o
MATCH (q:Question {id: 'Q-DIEU-03'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (o:AnswerOption {id: 'Q-DIEU-03-3'})
ON CREATE SET o.content = "108 cm²",
              o.isCorrect = false
ON MATCH SET o.content = "108 cm²",
             o.isCorrect = false
WITH o
MATCH (q:Question {id: 'Q-DIEU-03'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (o:AnswerOption {id: 'Q-DIEU-03-4'})
ON CREATE SET o.content = "27 cm²",
              o.isCorrect = false
ON MATCH SET o.content = "27 cm²",
             o.isCorrect = false
WITH o
MATCH (q:Question {id: 'Q-DIEU-03'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (q:Question {id: 'Q-DIEU-04'})
ON CREATE SET q.content = "Hình diều ABCD có AB = AD = 5 cm và CB = CD = 8 cm. Chu vi hình diều là:",
              q.type = "CALCULATION",
              q.difficulty = 1,
              q.explanation = "P = AB + AD + CB + CD = 5 + 5 + 8 + 8 = 26 cm."
ON MATCH SET q.content = "Hình diều ABCD có AB = AD = 5 cm và CB = CD = 8 cm. Chu vi hình diều là:",
             q.type = "CALCULATION",
             q.difficulty = 1,
             q.explanation = "P = AB + AD + CB + CD = 5 + 5 + 8 + 8 = 26 cm."
WITH q
MATCH (s:Shape {slug: 'hinh-dieu'})
MERGE (s)-[:HAS_QUESTION]->(q);

MERGE (o:AnswerOption {id: 'Q-DIEU-04-1'})
ON CREATE SET o.content = "13 cm",
              o.isCorrect = false
ON MATCH SET o.content = "13 cm",
             o.isCorrect = false
WITH o
MATCH (q:Question {id: 'Q-DIEU-04'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (o:AnswerOption {id: 'Q-DIEU-04-2'})
ON CREATE SET o.content = "26 cm",
              o.isCorrect = true
ON MATCH SET o.content = "26 cm",
             o.isCorrect = true
WITH o
MATCH (q:Question {id: 'Q-DIEU-04'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (o:AnswerOption {id: 'Q-DIEU-04-3'})
ON CREATE SET o.content = "40 cm",
              o.isCorrect = false
ON MATCH SET o.content = "40 cm",
             o.isCorrect = false
WITH o
MATCH (q:Question {id: 'Q-DIEU-04'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (o:AnswerOption {id: 'Q-DIEU-04-4'})
ON CREATE SET o.content = "52 cm",
              o.isCorrect = false
ON MATCH SET o.content = "52 cm",
             o.isCorrect = false
WITH o
MATCH (q:Question {id: 'Q-DIEU-04'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (q:Question {id: 'Q-DIEU-05'})
ON CREATE SET q.content = "Theo định nghĩa của bài học, hình thoi có phải là hình diều không?",
              q.type = "RECOGNITION",
              q.difficulty = 2,
              q.explanation = "Hình thoi có bốn cạnh bằng nhau nên chắc chắn có hai cặp cạnh kề bằng nhau, thoả mãn định nghĩa hình diều. Vậy hình thoi là một trường hợp đặc biệt của hình diều."
ON MATCH SET q.content = "Theo định nghĩa của bài học, hình thoi có phải là hình diều không?",
             q.type = "RECOGNITION",
             q.difficulty = 2,
             q.explanation = "Hình thoi có bốn cạnh bằng nhau nên chắc chắn có hai cặp cạnh kề bằng nhau, thoả mãn định nghĩa hình diều. Vậy hình thoi là một trường hợp đặc biệt của hình diều."
WITH q
MATCH (s:Shape {slug: 'hinh-dieu'})
MERGE (s)-[:HAS_QUESTION]->(q);

MERGE (o:AnswerOption {id: 'Q-DIEU-05-1'})
ON CREATE SET o.content = "Có, vì hình thoi có hai cặp cạnh kề bằng nhau",
              o.isCorrect = true
ON MATCH SET o.content = "Có, vì hình thoi có hai cặp cạnh kề bằng nhau",
             o.isCorrect = true
WITH o
MATCH (q:Question {id: 'Q-DIEU-05'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (o:AnswerOption {id: 'Q-DIEU-05-2'})
ON CREATE SET o.content = "Không, vì hình thoi có bốn cạnh bằng nhau",
              o.isCorrect = false
ON MATCH SET o.content = "Không, vì hình thoi có bốn cạnh bằng nhau",
             o.isCorrect = false
WITH o
MATCH (q:Question {id: 'Q-DIEU-05'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (o:AnswerOption {id: 'Q-DIEU-05-3'})
ON CREATE SET o.content = "Không, vì hình thoi là hình bình hành",
              o.isCorrect = false
ON MATCH SET o.content = "Không, vì hình thoi là hình bình hành",
             o.isCorrect = false
WITH o
MATCH (q:Question {id: 'Q-DIEU-05'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (o:AnswerOption {id: 'Q-DIEU-05-4'})
ON CREATE SET o.content = "Chỉ đúng khi hình thoi là hình vuông",
              o.isCorrect = false
ON MATCH SET o.content = "Chỉ đúng khi hình thoi là hình vuông",
             o.isCorrect = false
WITH o
MATCH (q:Question {id: 'Q-DIEU-05'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (q:Question {id: 'Q-HBH-01'})
ON CREATE SET q.content = "Hình bình hành là tứ giác có:",
              q.type = "THEORY",
              q.difficulty = 1,
              q.explanation = "Định nghĩa: hình bình hành là tứ giác có hai cặp cạnh đối song song. Chỉ có một cặp cạnh đối song song thì là hình thang."
ON MATCH SET q.content = "Hình bình hành là tứ giác có:",
             q.type = "THEORY",
             q.difficulty = 1,
             q.explanation = "Định nghĩa: hình bình hành là tứ giác có hai cặp cạnh đối song song. Chỉ có một cặp cạnh đối song song thì là hình thang."
WITH q
MATCH (s:Shape {slug: 'hinh-binh-hanh'})
MERGE (s)-[:HAS_QUESTION]->(q);

MERGE (o:AnswerOption {id: 'Q-HBH-01-1'})
ON CREATE SET o.content = "Hai cạnh đối song song",
              o.isCorrect = false
ON MATCH SET o.content = "Hai cạnh đối song song",
             o.isCorrect = false
WITH o
MATCH (q:Question {id: 'Q-HBH-01'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (o:AnswerOption {id: 'Q-HBH-01-2'})
ON CREATE SET o.content = "Hai cặp cạnh đối song song",
              o.isCorrect = true
ON MATCH SET o.content = "Hai cặp cạnh đối song song",
             o.isCorrect = true
WITH o
MATCH (q:Question {id: 'Q-HBH-01'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (o:AnswerOption {id: 'Q-HBH-01-3'})
ON CREATE SET o.content = "Bốn góc bằng nhau",
              o.isCorrect = false
ON MATCH SET o.content = "Bốn góc bằng nhau",
             o.isCorrect = false
WITH o
MATCH (q:Question {id: 'Q-HBH-01'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (o:AnswerOption {id: 'Q-HBH-01-4'})
ON CREATE SET o.content = "Hai đường chéo bằng nhau",
              o.isCorrect = false
ON MATCH SET o.content = "Hai đường chéo bằng nhau",
             o.isCorrect = false
WITH o
MATCH (q:Question {id: 'Q-HBH-01'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (q:Question {id: 'Q-HBH-02'})
ON CREATE SET q.content = "Trong hình bình hành, hai đường chéo:",
              q.type = "THEORY",
              q.difficulty = 1,
              q.explanation = "Tính chất của hình bình hành: hai đường chéo cắt nhau tại trung điểm của mỗi đường. Các tính chất còn lại chỉ đúng với hình chữ nhật hoặc hình thoi."
ON MATCH SET q.content = "Trong hình bình hành, hai đường chéo:",
             q.type = "THEORY",
             q.difficulty = 1,
             q.explanation = "Tính chất của hình bình hành: hai đường chéo cắt nhau tại trung điểm của mỗi đường. Các tính chất còn lại chỉ đúng với hình chữ nhật hoặc hình thoi."
WITH q
MATCH (s:Shape {slug: 'hinh-binh-hanh'})
MERGE (s)-[:HAS_QUESTION]->(q);

MERGE (o:AnswerOption {id: 'Q-HBH-02-1'})
ON CREATE SET o.content = "Bằng nhau",
              o.isCorrect = false
ON MATCH SET o.content = "Bằng nhau",
             o.isCorrect = false
WITH o
MATCH (q:Question {id: 'Q-HBH-02'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (o:AnswerOption {id: 'Q-HBH-02-2'})
ON CREATE SET o.content = "Vuông góc với nhau",
              o.isCorrect = false
ON MATCH SET o.content = "Vuông góc với nhau",
             o.isCorrect = false
WITH o
MATCH (q:Question {id: 'Q-HBH-02'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (o:AnswerOption {id: 'Q-HBH-02-3'})
ON CREATE SET o.content = "Cắt nhau tại trung điểm của mỗi đường",
              o.isCorrect = true
ON MATCH SET o.content = "Cắt nhau tại trung điểm của mỗi đường",
             o.isCorrect = true
WITH o
MATCH (q:Question {id: 'Q-HBH-02'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (o:AnswerOption {id: 'Q-HBH-02-4'})
ON CREATE SET o.content = "Là đường phân giác của các góc",
              o.isCorrect = false
ON MATCH SET o.content = "Là đường phân giác của các góc",
             o.isCorrect = false
WITH o
MATCH (q:Question {id: 'Q-HBH-02'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (q:Question {id: 'Q-HBH-03'})
ON CREATE SET q.content = "Hình bình hành ABCD có ∠A = 70°. Số đo ∠B là:",
              q.type = "CALCULATION",
              q.difficulty = 1,
              q.explanation = "Hai góc kề một cạnh của hình bình hành bù nhau: ∠B = 180° − 70° = 110°."
ON MATCH SET q.content = "Hình bình hành ABCD có ∠A = 70°. Số đo ∠B là:",
             q.type = "CALCULATION",
             q.difficulty = 1,
             q.explanation = "Hai góc kề một cạnh của hình bình hành bù nhau: ∠B = 180° − 70° = 110°."
WITH q
MATCH (s:Shape {slug: 'hinh-binh-hanh'})
MERGE (s)-[:HAS_QUESTION]->(q);

MERGE (o:AnswerOption {id: 'Q-HBH-03-1'})
ON CREATE SET o.content = "70°",
              o.isCorrect = false
ON MATCH SET o.content = "70°",
             o.isCorrect = false
WITH o
MATCH (q:Question {id: 'Q-HBH-03'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (o:AnswerOption {id: 'Q-HBH-03-2'})
ON CREATE SET o.content = "100°",
              o.isCorrect = false
ON MATCH SET o.content = "100°",
             o.isCorrect = false
WITH o
MATCH (q:Question {id: 'Q-HBH-03'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (o:AnswerOption {id: 'Q-HBH-03-3'})
ON CREATE SET o.content = "110°",
              o.isCorrect = true
ON MATCH SET o.content = "110°",
             o.isCorrect = true
WITH o
MATCH (q:Question {id: 'Q-HBH-03'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (o:AnswerOption {id: 'Q-HBH-03-4'})
ON CREATE SET o.content = "120°",
              o.isCorrect = false
ON MATCH SET o.content = "120°",
             o.isCorrect = false
WITH o
MATCH (q:Question {id: 'Q-HBH-03'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (q:Question {id: 'Q-HBH-04'})
ON CREATE SET q.content = "Hình bình hành có hai cạnh kề dài 6 cm và 9 cm. Chu vi của nó là:",
              q.type = "CALCULATION",
              q.difficulty = 1,
              q.explanation = "P = 2(a + b) = 2 · (6 + 9) = 30 cm."
ON MATCH SET q.content = "Hình bình hành có hai cạnh kề dài 6 cm và 9 cm. Chu vi của nó là:",
             q.type = "CALCULATION",
             q.difficulty = 1,
             q.explanation = "P = 2(a + b) = 2 · (6 + 9) = 30 cm."
WITH q
MATCH (s:Shape {slug: 'hinh-binh-hanh'})
MERGE (s)-[:HAS_QUESTION]->(q);

MERGE (o:AnswerOption {id: 'Q-HBH-04-1'})
ON CREATE SET o.content = "15 cm",
              o.isCorrect = false
ON MATCH SET o.content = "15 cm",
             o.isCorrect = false
WITH o
MATCH (q:Question {id: 'Q-HBH-04'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (o:AnswerOption {id: 'Q-HBH-04-2'})
ON CREATE SET o.content = "30 cm",
              o.isCorrect = true
ON MATCH SET o.content = "30 cm",
             o.isCorrect = true
WITH o
MATCH (q:Question {id: 'Q-HBH-04'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (o:AnswerOption {id: 'Q-HBH-04-3'})
ON CREATE SET o.content = "54 cm",
              o.isCorrect = false
ON MATCH SET o.content = "54 cm",
             o.isCorrect = false
WITH o
MATCH (q:Question {id: 'Q-HBH-04'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (o:AnswerOption {id: 'Q-HBH-04-4'})
ON CREATE SET o.content = "60 cm",
              o.isCorrect = false
ON MATCH SET o.content = "60 cm",
             o.isCorrect = false
WITH o
MATCH (q:Question {id: 'Q-HBH-04'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (q:Question {id: 'Q-HBH-05'})
ON CREATE SET q.content = "Tứ giác nào sau đây chắc chắn là hình bình hành?",
              q.type = "RECOGNITION",
              q.difficulty = 2,
              q.explanation = "Dấu hiệu nhận biết: tứ giác có hai đường chéo cắt nhau tại trung điểm của mỗi đường là hình bình hành. Chỉ có hai cạnh đối bằng nhau, hoặc hai đường chéo bằng nhau, hoặc một cặp cạnh đối song song thì chưa đủ."
ON MATCH SET q.content = "Tứ giác nào sau đây chắc chắn là hình bình hành?",
             q.type = "RECOGNITION",
             q.difficulty = 2,
             q.explanation = "Dấu hiệu nhận biết: tứ giác có hai đường chéo cắt nhau tại trung điểm của mỗi đường là hình bình hành. Chỉ có hai cạnh đối bằng nhau, hoặc hai đường chéo bằng nhau, hoặc một cặp cạnh đối song song thì chưa đủ."
WITH q
MATCH (s:Shape {slug: 'hinh-binh-hanh'})
MERGE (s)-[:HAS_QUESTION]->(q);

MERGE (o:AnswerOption {id: 'Q-HBH-05-1'})
ON CREATE SET o.content = "Tứ giác có hai cạnh đối bằng nhau",
              o.isCorrect = false
ON MATCH SET o.content = "Tứ giác có hai cạnh đối bằng nhau",
             o.isCorrect = false
WITH o
MATCH (q:Question {id: 'Q-HBH-05'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (o:AnswerOption {id: 'Q-HBH-05-2'})
ON CREATE SET o.content = "Tứ giác có hai đường chéo cắt nhau tại trung điểm của mỗi đường",
              o.isCorrect = true
ON MATCH SET o.content = "Tứ giác có hai đường chéo cắt nhau tại trung điểm của mỗi đường",
             o.isCorrect = true
WITH o
MATCH (q:Question {id: 'Q-HBH-05'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (o:AnswerOption {id: 'Q-HBH-05-3'})
ON CREATE SET o.content = "Tứ giác có hai đường chéo bằng nhau",
              o.isCorrect = false
ON MATCH SET o.content = "Tứ giác có hai đường chéo bằng nhau",
             o.isCorrect = false
WITH o
MATCH (q:Question {id: 'Q-HBH-05'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (o:AnswerOption {id: 'Q-HBH-05-4'})
ON CREATE SET o.content = "Tứ giác có một cặp cạnh đối song song",
              o.isCorrect = false
ON MATCH SET o.content = "Tứ giác có một cặp cạnh đối song song",
             o.isCorrect = false
WITH o
MATCH (q:Question {id: 'Q-HBH-05'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (q:Question {id: 'Q-HCN-01'})
ON CREATE SET q.content = "Hình chữ nhật là tứ giác có:",
              q.type = "THEORY",
              q.difficulty = 1,
              q.explanation = "Định nghĩa: hình chữ nhật là tứ giác có bốn góc vuông."
ON MATCH SET q.content = "Hình chữ nhật là tứ giác có:",
             q.type = "THEORY",
             q.difficulty = 1,
             q.explanation = "Định nghĩa: hình chữ nhật là tứ giác có bốn góc vuông."
WITH q
MATCH (s:Shape {slug: 'hinh-chu-nhat'})
MERGE (s)-[:HAS_QUESTION]->(q);

MERGE (o:AnswerOption {id: 'Q-HCN-01-1'})
ON CREATE SET o.content = "Bốn cạnh bằng nhau",
              o.isCorrect = false
ON MATCH SET o.content = "Bốn cạnh bằng nhau",
             o.isCorrect = false
WITH o
MATCH (q:Question {id: 'Q-HCN-01'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (o:AnswerOption {id: 'Q-HCN-01-2'})
ON CREATE SET o.content = "Bốn góc vuông",
              o.isCorrect = true
ON MATCH SET o.content = "Bốn góc vuông",
             o.isCorrect = true
WITH o
MATCH (q:Question {id: 'Q-HCN-01'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (o:AnswerOption {id: 'Q-HCN-01-3'})
ON CREATE SET o.content = "Hai đường chéo vuông góc",
              o.isCorrect = false
ON MATCH SET o.content = "Hai đường chéo vuông góc",
             o.isCorrect = false
WITH o
MATCH (q:Question {id: 'Q-HCN-01'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (o:AnswerOption {id: 'Q-HCN-01-4'})
ON CREATE SET o.content = "Hai cạnh kề bằng nhau",
              o.isCorrect = false
ON MATCH SET o.content = "Hai cạnh kề bằng nhau",
             o.isCorrect = false
WITH o
MATCH (q:Question {id: 'Q-HCN-01'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (q:Question {id: 'Q-HCN-02'})
ON CREATE SET q.content = "Theo định nghĩa bao hàm của bài học, hình chữ nhật có phải là hình thang cân không?",
              q.type = "THEORY",
              q.difficulty = 3,
              q.explanation = "Hình chữ nhật có hai cạnh đối song song nên là hình thang, và hai góc kề một đáy cùng bằng 90° nên bằng nhau. Vậy hình chữ nhật là hình thang cân."
ON MATCH SET q.content = "Theo định nghĩa bao hàm của bài học, hình chữ nhật có phải là hình thang cân không?",
             q.type = "THEORY",
             q.difficulty = 3,
             q.explanation = "Hình chữ nhật có hai cạnh đối song song nên là hình thang, và hai góc kề một đáy cùng bằng 90° nên bằng nhau. Vậy hình chữ nhật là hình thang cân."
WITH q
MATCH (s:Shape {slug: 'hinh-chu-nhat'})
MERGE (s)-[:HAS_QUESTION]->(q);

MERGE (o:AnswerOption {id: 'Q-HCN-02-1'})
ON CREATE SET o.content = "Có, vì hình chữ nhật là hình thang có hai góc kề một đáy bằng nhau",
              o.isCorrect = true
ON MATCH SET o.content = "Có, vì hình chữ nhật là hình thang có hai góc kề một đáy bằng nhau",
             o.isCorrect = true
WITH o
MATCH (q:Question {id: 'Q-HCN-02'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (o:AnswerOption {id: 'Q-HCN-02-2'})
ON CREATE SET o.content = "Không, vì hình chữ nhật có bốn góc vuông",
              o.isCorrect = false
ON MATCH SET o.content = "Không, vì hình chữ nhật có bốn góc vuông",
             o.isCorrect = false
WITH o
MATCH (q:Question {id: 'Q-HCN-02'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (o:AnswerOption {id: 'Q-HCN-02-3'})
ON CREATE SET o.content = "Không, vì hai cạnh bên của hình chữ nhật song song",
              o.isCorrect = false
ON MATCH SET o.content = "Không, vì hai cạnh bên của hình chữ nhật song song",
             o.isCorrect = false
WITH o
MATCH (q:Question {id: 'Q-HCN-02'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (o:AnswerOption {id: 'Q-HCN-02-4'})
ON CREATE SET o.content = "Chỉ đúng khi hình chữ nhật là hình vuông",
              o.isCorrect = false
ON MATCH SET o.content = "Chỉ đúng khi hình chữ nhật là hình vuông",
             o.isCorrect = false
WITH o
MATCH (q:Question {id: 'Q-HCN-02'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (q:Question {id: 'Q-HCN-03'})
ON CREATE SET q.content = "Hình chữ nhật có hai cạnh 6 cm và 8 cm. Độ dài đường chéo là:",
              q.type = "CALCULATION",
              q.difficulty = 2,
              q.explanation = "Đường chéo là cạnh huyền của tam giác vuông có hai cạnh góc vuông 6 cm và 8 cm: d = √(6² + 8²) = √100 = 10 cm."
ON MATCH SET q.content = "Hình chữ nhật có hai cạnh 6 cm và 8 cm. Độ dài đường chéo là:",
             q.type = "CALCULATION",
             q.difficulty = 2,
             q.explanation = "Đường chéo là cạnh huyền của tam giác vuông có hai cạnh góc vuông 6 cm và 8 cm: d = √(6² + 8²) = √100 = 10 cm."
WITH q
MATCH (s:Shape {slug: 'hinh-chu-nhat'})
MERGE (s)-[:HAS_QUESTION]->(q);

MERGE (o:AnswerOption {id: 'Q-HCN-03-1'})
ON CREATE SET o.content = "14 cm",
              o.isCorrect = false
ON MATCH SET o.content = "14 cm",
             o.isCorrect = false
WITH o
MATCH (q:Question {id: 'Q-HCN-03'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (o:AnswerOption {id: 'Q-HCN-03-2'})
ON CREATE SET o.content = "12 cm",
              o.isCorrect = false
ON MATCH SET o.content = "12 cm",
             o.isCorrect = false
WITH o
MATCH (q:Question {id: 'Q-HCN-03'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (o:AnswerOption {id: 'Q-HCN-03-3'})
ON CREATE SET o.content = "10 cm",
              o.isCorrect = true
ON MATCH SET o.content = "10 cm",
             o.isCorrect = true
WITH o
MATCH (q:Question {id: 'Q-HCN-03'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (o:AnswerOption {id: 'Q-HCN-03-4'})
ON CREATE SET o.content = "7 cm",
              o.isCorrect = false
ON MATCH SET o.content = "7 cm",
             o.isCorrect = false
WITH o
MATCH (q:Question {id: 'Q-HCN-03'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (q:Question {id: 'Q-HCN-04'})
ON CREATE SET q.content = "Hình chữ nhật có chiều dài 12 cm, chiều rộng 5 cm. Diện tích là:",
              q.type = "CALCULATION",
              q.difficulty = 1,
              q.explanation = "S = a · b = 12 · 5 = 60 cm²."
ON MATCH SET q.content = "Hình chữ nhật có chiều dài 12 cm, chiều rộng 5 cm. Diện tích là:",
             q.type = "CALCULATION",
             q.difficulty = 1,
             q.explanation = "S = a · b = 12 · 5 = 60 cm²."
WITH q
MATCH (s:Shape {slug: 'hinh-chu-nhat'})
MERGE (s)-[:HAS_QUESTION]->(q);

MERGE (o:AnswerOption {id: 'Q-HCN-04-1'})
ON CREATE SET o.content = "17 cm²",
              o.isCorrect = false
ON MATCH SET o.content = "17 cm²",
             o.isCorrect = false
WITH o
MATCH (q:Question {id: 'Q-HCN-04'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (o:AnswerOption {id: 'Q-HCN-04-2'})
ON CREATE SET o.content = "34 cm²",
              o.isCorrect = false
ON MATCH SET o.content = "34 cm²",
             o.isCorrect = false
WITH o
MATCH (q:Question {id: 'Q-HCN-04'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (o:AnswerOption {id: 'Q-HCN-04-3'})
ON CREATE SET o.content = "60 cm²",
              o.isCorrect = true
ON MATCH SET o.content = "60 cm²",
             o.isCorrect = true
WITH o
MATCH (q:Question {id: 'Q-HCN-04'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (o:AnswerOption {id: 'Q-HCN-04-4'})
ON CREATE SET o.content = "120 cm²",
              o.isCorrect = false
ON MATCH SET o.content = "120 cm²",
             o.isCorrect = false
WITH o
MATCH (q:Question {id: 'Q-HCN-04'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (q:Question {id: 'Q-HCN-05'})
ON CREATE SET q.content = "Hình bình hành ABCD có hai đường chéo AC = BD. Tứ giác ABCD là hình gì?",
              q.type = "RECOGNITION",
              q.difficulty = 2,
              q.explanation = "Hình bình hành có hai đường chéo bằng nhau là hình chữ nhật."
ON MATCH SET q.content = "Hình bình hành ABCD có hai đường chéo AC = BD. Tứ giác ABCD là hình gì?",
             q.type = "RECOGNITION",
             q.difficulty = 2,
             q.explanation = "Hình bình hành có hai đường chéo bằng nhau là hình chữ nhật."
WITH q
MATCH (s:Shape {slug: 'hinh-chu-nhat'})
MERGE (s)-[:HAS_QUESTION]->(q);

MERGE (o:AnswerOption {id: 'Q-HCN-05-1'})
ON CREATE SET o.content = "Hình thoi",
              o.isCorrect = false
ON MATCH SET o.content = "Hình thoi",
             o.isCorrect = false
WITH o
MATCH (q:Question {id: 'Q-HCN-05'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (o:AnswerOption {id: 'Q-HCN-05-2'})
ON CREATE SET o.content = "Hình chữ nhật",
              o.isCorrect = true
ON MATCH SET o.content = "Hình chữ nhật",
             o.isCorrect = true
WITH o
MATCH (q:Question {id: 'Q-HCN-05'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (o:AnswerOption {id: 'Q-HCN-05-3'})
ON CREATE SET o.content = "Hình diều",
              o.isCorrect = false
ON MATCH SET o.content = "Hình diều",
             o.isCorrect = false
WITH o
MATCH (q:Question {id: 'Q-HCN-05'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (o:AnswerOption {id: 'Q-HCN-05-4'})
ON CREATE SET o.content = "Không kết luận được",
              o.isCorrect = false
ON MATCH SET o.content = "Không kết luận được",
             o.isCorrect = false
WITH o
MATCH (q:Question {id: 'Q-HCN-05'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (q:Question {id: 'Q-HT-01'})
ON CREATE SET q.content = "Hình thang là tứ giác có:",
              q.type = "THEORY",
              q.difficulty = 1,
              q.explanation = "Theo định nghĩa bao hàm dùng trong bài học, hình thang là tứ giác có ít nhất một cặp cạnh đối song song."
ON MATCH SET q.content = "Hình thang là tứ giác có:",
             q.type = "THEORY",
             q.difficulty = 1,
             q.explanation = "Theo định nghĩa bao hàm dùng trong bài học, hình thang là tứ giác có ít nhất một cặp cạnh đối song song."
WITH q
MATCH (s:Shape {slug: 'hinh-thang'})
MERGE (s)-[:HAS_QUESTION]->(q);

MERGE (o:AnswerOption {id: 'Q-HT-01-1'})
ON CREATE SET o.content = "Bốn cạnh bằng nhau",
              o.isCorrect = false
ON MATCH SET o.content = "Bốn cạnh bằng nhau",
             o.isCorrect = false
WITH o
MATCH (q:Question {id: 'Q-HT-01'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (o:AnswerOption {id: 'Q-HT-01-2'})
ON CREATE SET o.content = "Hai cặp cạnh đối song song",
              o.isCorrect = false
ON MATCH SET o.content = "Hai cặp cạnh đối song song",
             o.isCorrect = false
WITH o
MATCH (q:Question {id: 'Q-HT-01'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (o:AnswerOption {id: 'Q-HT-01-3'})
ON CREATE SET o.content = "Ít nhất một cặp cạnh đối song song",
              o.isCorrect = true
ON MATCH SET o.content = "Ít nhất một cặp cạnh đối song song",
             o.isCorrect = true
WITH o
MATCH (q:Question {id: 'Q-HT-01'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (o:AnswerOption {id: 'Q-HT-01-4'})
ON CREATE SET o.content = "Bốn góc vuông",
              o.isCorrect = false
ON MATCH SET o.content = "Bốn góc vuông",
             o.isCorrect = false
WITH o
MATCH (q:Question {id: 'Q-HT-01'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (q:Question {id: 'Q-HT-02'})
ON CREATE SET q.content = "Hình thang ABCD có AB ∥ CD. Khẳng định nào sau đây luôn đúng?",
              q.type = "THEORY",
              q.difficulty = 2,
              q.explanation = "AB ∥ CD và AD là cạnh bên nên ∠A và ∠D là hai góc trong cùng phía, tổng bằng 180°. Các khẳng định còn lại chỉ đúng với một số hình thang đặc biệt."
ON MATCH SET q.content = "Hình thang ABCD có AB ∥ CD. Khẳng định nào sau đây luôn đúng?",
             q.type = "THEORY",
             q.difficulty = 2,
             q.explanation = "AB ∥ CD và AD là cạnh bên nên ∠A và ∠D là hai góc trong cùng phía, tổng bằng 180°. Các khẳng định còn lại chỉ đúng với một số hình thang đặc biệt."
WITH q
MATCH (s:Shape {slug: 'hinh-thang'})
MERGE (s)-[:HAS_QUESTION]->(q);

MERGE (o:AnswerOption {id: 'Q-HT-02-1'})
ON CREATE SET o.content = "∠A + ∠D = 180°",
              o.isCorrect = true
ON MATCH SET o.content = "∠A + ∠D = 180°",
             o.isCorrect = true
WITH o
MATCH (q:Question {id: 'Q-HT-02'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (o:AnswerOption {id: 'Q-HT-02-2'})
ON CREATE SET o.content = "∠A = ∠C",
              o.isCorrect = false
ON MATCH SET o.content = "∠A = ∠C",
             o.isCorrect = false
WITH o
MATCH (q:Question {id: 'Q-HT-02'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (o:AnswerOption {id: 'Q-HT-02-3'})
ON CREATE SET o.content = "∠A + ∠B = 180°",
              o.isCorrect = false
ON MATCH SET o.content = "∠A + ∠B = 180°",
             o.isCorrect = false
WITH o
MATCH (q:Question {id: 'Q-HT-02'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (o:AnswerOption {id: 'Q-HT-02-4'})
ON CREATE SET o.content = "∠A = ∠D",
              o.isCorrect = false
ON MATCH SET o.content = "∠A = ∠D",
             o.isCorrect = false
WITH o
MATCH (q:Question {id: 'Q-HT-02'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (q:Question {id: 'Q-HT-03'})
ON CREATE SET q.content = "Hình thang có hai đáy dài 7 cm và 13 cm, chiều cao 5 cm. Diện tích hình thang là:",
              q.type = "CALCULATION",
              q.difficulty = 1,
              q.explanation = "S = (a + b) · h / 2 = (7 + 13) · 5 / 2 = 100 / 2 = 50 cm²."
ON MATCH SET q.content = "Hình thang có hai đáy dài 7 cm và 13 cm, chiều cao 5 cm. Diện tích hình thang là:",
             q.type = "CALCULATION",
             q.difficulty = 1,
             q.explanation = "S = (a + b) · h / 2 = (7 + 13) · 5 / 2 = 100 / 2 = 50 cm²."
WITH q
MATCH (s:Shape {slug: 'hinh-thang'})
MERGE (s)-[:HAS_QUESTION]->(q);

MERGE (o:AnswerOption {id: 'Q-HT-03-1'})
ON CREATE SET o.content = "45 cm²",
              o.isCorrect = false
ON MATCH SET o.content = "45 cm²",
             o.isCorrect = false
WITH o
MATCH (q:Question {id: 'Q-HT-03'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (o:AnswerOption {id: 'Q-HT-03-2'})
ON CREATE SET o.content = "50 cm²",
              o.isCorrect = true
ON MATCH SET o.content = "50 cm²",
             o.isCorrect = true
WITH o
MATCH (q:Question {id: 'Q-HT-03'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (o:AnswerOption {id: 'Q-HT-03-3'})
ON CREATE SET o.content = "65 cm²",
              o.isCorrect = false
ON MATCH SET o.content = "65 cm²",
             o.isCorrect = false
WITH o
MATCH (q:Question {id: 'Q-HT-03'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (o:AnswerOption {id: 'Q-HT-03-4'})
ON CREATE SET o.content = "100 cm²",
              o.isCorrect = false
ON MATCH SET o.content = "100 cm²",
             o.isCorrect = false
WITH o
MATCH (q:Question {id: 'Q-HT-03'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (q:Question {id: 'Q-HT-04'})
ON CREATE SET q.content = "Hai đáy của hình thang dài 8 cm và 14 cm. Đường trung bình của hình thang dài:",
              q.type = "CALCULATION",
              q.difficulty = 1,
              q.explanation = "Đường trung bình bằng nửa tổng hai đáy: (8 + 14) / 2 = 11 cm."
ON MATCH SET q.content = "Hai đáy của hình thang dài 8 cm và 14 cm. Đường trung bình của hình thang dài:",
             q.type = "CALCULATION",
             q.difficulty = 1,
             q.explanation = "Đường trung bình bằng nửa tổng hai đáy: (8 + 14) / 2 = 11 cm."
WITH q
MATCH (s:Shape {slug: 'hinh-thang'})
MERGE (s)-[:HAS_QUESTION]->(q);

MERGE (o:AnswerOption {id: 'Q-HT-04-1'})
ON CREATE SET o.content = "10 cm",
              o.isCorrect = false
ON MATCH SET o.content = "10 cm",
             o.isCorrect = false
WITH o
MATCH (q:Question {id: 'Q-HT-04'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (o:AnswerOption {id: 'Q-HT-04-2'})
ON CREATE SET o.content = "11 cm",
              o.isCorrect = true
ON MATCH SET o.content = "11 cm",
             o.isCorrect = true
WITH o
MATCH (q:Question {id: 'Q-HT-04'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (o:AnswerOption {id: 'Q-HT-04-3'})
ON CREATE SET o.content = "12 cm",
              o.isCorrect = false
ON MATCH SET o.content = "12 cm",
             o.isCorrect = false
WITH o
MATCH (q:Question {id: 'Q-HT-04'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (o:AnswerOption {id: 'Q-HT-04-4'})
ON CREATE SET o.content = "22 cm",
              o.isCorrect = false
ON MATCH SET o.content = "22 cm",
             o.isCorrect = false
WITH o
MATCH (q:Question {id: 'Q-HT-04'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (q:Question {id: 'Q-HT-05'})
ON CREATE SET q.content = "Tứ giác ABCD có AB ∥ CD, còn AD không song song với BC. Tứ giác ABCD là hình gì?",
              q.type = "RECOGNITION",
              q.difficulty = 1,
              q.explanation = "Tứ giác có một cặp cạnh đối song song là hình thang. Vì AD không song song với BC nên ABCD không phải hình bình hành, hình thoi hay hình chữ nhật."
ON MATCH SET q.content = "Tứ giác ABCD có AB ∥ CD, còn AD không song song với BC. Tứ giác ABCD là hình gì?",
             q.type = "RECOGNITION",
             q.difficulty = 1,
             q.explanation = "Tứ giác có một cặp cạnh đối song song là hình thang. Vì AD không song song với BC nên ABCD không phải hình bình hành, hình thoi hay hình chữ nhật."
WITH q
MATCH (s:Shape {slug: 'hinh-thang'})
MERGE (s)-[:HAS_QUESTION]->(q);

MERGE (o:AnswerOption {id: 'Q-HT-05-1'})
ON CREATE SET o.content = "Hình thang",
              o.isCorrect = true
ON MATCH SET o.content = "Hình thang",
             o.isCorrect = true
WITH o
MATCH (q:Question {id: 'Q-HT-05'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (o:AnswerOption {id: 'Q-HT-05-2'})
ON CREATE SET o.content = "Hình bình hành",
              o.isCorrect = false
ON MATCH SET o.content = "Hình bình hành",
             o.isCorrect = false
WITH o
MATCH (q:Question {id: 'Q-HT-05'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (o:AnswerOption {id: 'Q-HT-05-3'})
ON CREATE SET o.content = "Hình thoi",
              o.isCorrect = false
ON MATCH SET o.content = "Hình thoi",
             o.isCorrect = false
WITH o
MATCH (q:Question {id: 'Q-HT-05'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (o:AnswerOption {id: 'Q-HT-05-4'})
ON CREATE SET o.content = "Hình chữ nhật",
              o.isCorrect = false
ON MATCH SET o.content = "Hình chữ nhật",
             o.isCorrect = false
WITH o
MATCH (q:Question {id: 'Q-HT-05'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (q:Question {id: 'Q-HTC-01'})
ON CREATE SET q.content = "Hình thang cân là hình thang có:",
              q.type = "THEORY",
              q.difficulty = 1,
              q.explanation = "Định nghĩa: hình thang cân là hình thang có hai góc kề một đáy bằng nhau."
ON MATCH SET q.content = "Hình thang cân là hình thang có:",
             q.type = "THEORY",
             q.difficulty = 1,
             q.explanation = "Định nghĩa: hình thang cân là hình thang có hai góc kề một đáy bằng nhau."
WITH q
MATCH (s:Shape {slug: 'hinh-thang-can'})
MERGE (s)-[:HAS_QUESTION]->(q);

MERGE (o:AnswerOption {id: 'Q-HTC-01-1'})
ON CREATE SET o.content = "Hai cạnh bên song song",
              o.isCorrect = false
ON MATCH SET o.content = "Hai cạnh bên song song",
             o.isCorrect = false
WITH o
MATCH (q:Question {id: 'Q-HTC-01'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (o:AnswerOption {id: 'Q-HTC-01-2'})
ON CREATE SET o.content = "Hai góc kề một đáy bằng nhau",
              o.isCorrect = true
ON MATCH SET o.content = "Hai góc kề một đáy bằng nhau",
             o.isCorrect = true
WITH o
MATCH (q:Question {id: 'Q-HTC-01'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (o:AnswerOption {id: 'Q-HTC-01-3'})
ON CREATE SET o.content = "Hai đường chéo vuông góc",
              o.isCorrect = false
ON MATCH SET o.content = "Hai đường chéo vuông góc",
             o.isCorrect = false
WITH o
MATCH (q:Question {id: 'Q-HTC-01'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (o:AnswerOption {id: 'Q-HTC-01-4'})
ON CREATE SET o.content = "Bốn cạnh bằng nhau",
              o.isCorrect = false
ON MATCH SET o.content = "Bốn cạnh bằng nhau",
             o.isCorrect = false
WITH o
MATCH (q:Question {id: 'Q-HTC-01'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (q:Question {id: 'Q-HTC-02'})
ON CREATE SET q.content = "Trong hình thang cân, hai đường chéo:",
              q.type = "THEORY",
              q.difficulty = 2,
              q.explanation = "Tính chất của hình thang cân: hai đường chéo bằng nhau. Hai đường chéo của hình thang cân nói chung không vuông góc và không cắt nhau tại trung điểm."
ON MATCH SET q.content = "Trong hình thang cân, hai đường chéo:",
             q.type = "THEORY",
             q.difficulty = 2,
             q.explanation = "Tính chất của hình thang cân: hai đường chéo bằng nhau. Hai đường chéo của hình thang cân nói chung không vuông góc và không cắt nhau tại trung điểm."
WITH q
MATCH (s:Shape {slug: 'hinh-thang-can'})
MERGE (s)-[:HAS_QUESTION]->(q);

MERGE (o:AnswerOption {id: 'Q-HTC-02-1'})
ON CREATE SET o.content = "Vuông góc với nhau",
              o.isCorrect = false
ON MATCH SET o.content = "Vuông góc với nhau",
             o.isCorrect = false
WITH o
MATCH (q:Question {id: 'Q-HTC-02'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (o:AnswerOption {id: 'Q-HTC-02-2'})
ON CREATE SET o.content = "Bằng nhau",
              o.isCorrect = true
ON MATCH SET o.content = "Bằng nhau",
             o.isCorrect = true
WITH o
MATCH (q:Question {id: 'Q-HTC-02'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (o:AnswerOption {id: 'Q-HTC-02-3'})
ON CREATE SET o.content = "Song song với nhau",
              o.isCorrect = false
ON MATCH SET o.content = "Song song với nhau",
             o.isCorrect = false
WITH o
MATCH (q:Question {id: 'Q-HTC-02'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (o:AnswerOption {id: 'Q-HTC-02-4'})
ON CREATE SET o.content = "Cắt nhau tại trung điểm của mỗi đường",
              o.isCorrect = false
ON MATCH SET o.content = "Cắt nhau tại trung điểm của mỗi đường",
             o.isCorrect = false
WITH o
MATCH (q:Question {id: 'Q-HTC-02'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (q:Question {id: 'Q-HTC-03'})
ON CREATE SET q.content = "Hình thang cân ABCD (AB ∥ CD) có ∠A = 75°. Số đo ∠D là:",
              q.type = "CALCULATION",
              q.difficulty = 1,
              q.explanation = "AB ∥ CD nên ∠A + ∠D = 180°. Suy ra ∠D = 180° − 75° = 105°."
ON MATCH SET q.content = "Hình thang cân ABCD (AB ∥ CD) có ∠A = 75°. Số đo ∠D là:",
             q.type = "CALCULATION",
             q.difficulty = 1,
             q.explanation = "AB ∥ CD nên ∠A + ∠D = 180°. Suy ra ∠D = 180° − 75° = 105°."
WITH q
MATCH (s:Shape {slug: 'hinh-thang-can'})
MERGE (s)-[:HAS_QUESTION]->(q);

MERGE (o:AnswerOption {id: 'Q-HTC-03-1'})
ON CREATE SET o.content = "75°",
              o.isCorrect = false
ON MATCH SET o.content = "75°",
             o.isCorrect = false
WITH o
MATCH (q:Question {id: 'Q-HTC-03'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (o:AnswerOption {id: 'Q-HTC-03-2'})
ON CREATE SET o.content = "95°",
              o.isCorrect = false
ON MATCH SET o.content = "95°",
             o.isCorrect = false
WITH o
MATCH (q:Question {id: 'Q-HTC-03'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (o:AnswerOption {id: 'Q-HTC-03-3'})
ON CREATE SET o.content = "105°",
              o.isCorrect = true
ON MATCH SET o.content = "105°",
             o.isCorrect = true
WITH o
MATCH (q:Question {id: 'Q-HTC-03'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (o:AnswerOption {id: 'Q-HTC-03-4'})
ON CREATE SET o.content = "115°",
              o.isCorrect = false
ON MATCH SET o.content = "115°",
             o.isCorrect = false
WITH o
MATCH (q:Question {id: 'Q-HTC-03'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (q:Question {id: 'Q-HTC-04'})
ON CREATE SET q.content = "Hình thang cân ABCD có đường chéo AC = 9 cm. Độ dài đường chéo BD là:",
              q.type = "CALCULATION",
              q.difficulty = 1,
              q.explanation = "Trong hình thang cân hai đường chéo bằng nhau, nên BD = AC = 9 cm."
ON MATCH SET q.content = "Hình thang cân ABCD có đường chéo AC = 9 cm. Độ dài đường chéo BD là:",
             q.type = "CALCULATION",
             q.difficulty = 1,
             q.explanation = "Trong hình thang cân hai đường chéo bằng nhau, nên BD = AC = 9 cm."
WITH q
MATCH (s:Shape {slug: 'hinh-thang-can'})
MERGE (s)-[:HAS_QUESTION]->(q);

MERGE (o:AnswerOption {id: 'Q-HTC-04-1'})
ON CREATE SET o.content = "6 cm",
              o.isCorrect = false
ON MATCH SET o.content = "6 cm",
             o.isCorrect = false
WITH o
MATCH (q:Question {id: 'Q-HTC-04'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (o:AnswerOption {id: 'Q-HTC-04-2'})
ON CREATE SET o.content = "9 cm",
              o.isCorrect = true
ON MATCH SET o.content = "9 cm",
             o.isCorrect = true
WITH o
MATCH (q:Question {id: 'Q-HTC-04'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (o:AnswerOption {id: 'Q-HTC-04-3'})
ON CREATE SET o.content = "18 cm",
              o.isCorrect = false
ON MATCH SET o.content = "18 cm",
             o.isCorrect = false
WITH o
MATCH (q:Question {id: 'Q-HTC-04'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (o:AnswerOption {id: 'Q-HTC-04-4'})
ON CREATE SET o.content = "4,5 cm",
              o.isCorrect = false
ON MATCH SET o.content = "4,5 cm",
             o.isCorrect = false
WITH o
MATCH (q:Question {id: 'Q-HTC-04'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (q:Question {id: 'Q-HTC-05'})
ON CREATE SET q.content = "Với một hình thang, dấu hiệu nào đủ để kết luận đó là hình thang cân?",
              q.type = "RECOGNITION",
              q.difficulty = 3,
              q.explanation = "Hình thang có hai đường chéo bằng nhau là hình thang cân. Hai cạnh bên bằng nhau chưa đủ (hình bình hành không phải chữ nhật cũng có hai cạnh bên bằng nhau). Hai đáy bằng nhau thì là hình bình hành. Một góc vuông chưa đủ (hình thang vuông)."
ON MATCH SET q.content = "Với một hình thang, dấu hiệu nào đủ để kết luận đó là hình thang cân?",
             q.type = "RECOGNITION",
             q.difficulty = 3,
             q.explanation = "Hình thang có hai đường chéo bằng nhau là hình thang cân. Hai cạnh bên bằng nhau chưa đủ (hình bình hành không phải chữ nhật cũng có hai cạnh bên bằng nhau). Hai đáy bằng nhau thì là hình bình hành. Một góc vuông chưa đủ (hình thang vuông)."
WITH q
MATCH (s:Shape {slug: 'hinh-thang-can'})
MERGE (s)-[:HAS_QUESTION]->(q);

MERGE (o:AnswerOption {id: 'Q-HTC-05-1'})
ON CREATE SET o.content = "Hai cạnh bên bằng nhau",
              o.isCorrect = false
ON MATCH SET o.content = "Hai cạnh bên bằng nhau",
             o.isCorrect = false
WITH o
MATCH (q:Question {id: 'Q-HTC-05'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (o:AnswerOption {id: 'Q-HTC-05-2'})
ON CREATE SET o.content = "Hai đường chéo bằng nhau",
              o.isCorrect = true
ON MATCH SET o.content = "Hai đường chéo bằng nhau",
             o.isCorrect = true
WITH o
MATCH (q:Question {id: 'Q-HTC-05'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (o:AnswerOption {id: 'Q-HTC-05-3'})
ON CREATE SET o.content = "Hai đáy bằng nhau",
              o.isCorrect = false
ON MATCH SET o.content = "Hai đáy bằng nhau",
             o.isCorrect = false
WITH o
MATCH (q:Question {id: 'Q-HTC-05'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (o:AnswerOption {id: 'Q-HTC-05-4'})
ON CREATE SET o.content = "Có một góc vuông",
              o.isCorrect = false
ON MATCH SET o.content = "Có một góc vuông",
             o.isCorrect = false
WITH o
MATCH (q:Question {id: 'Q-HTC-05'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (q:Question {id: 'Q-TG-01'})
ON CREATE SET q.content = "Tổng bốn góc của một tứ giác bằng bao nhiêu?",
              q.type = "THEORY",
              q.difficulty = 1,
              q.explanation = "Kẻ một đường chéo, tứ giác được chia thành hai tam giác. Mỗi tam giác có tổng ba góc bằng 180°, nên tổng bốn góc của tứ giác là 2 × 180° = 360°."
ON MATCH SET q.content = "Tổng bốn góc của một tứ giác bằng bao nhiêu?",
             q.type = "THEORY",
             q.difficulty = 1,
             q.explanation = "Kẻ một đường chéo, tứ giác được chia thành hai tam giác. Mỗi tam giác có tổng ba góc bằng 180°, nên tổng bốn góc của tứ giác là 2 × 180° = 360°."
WITH q
MATCH (s:Shape {slug: 'tu-giac'})
MERGE (s)-[:HAS_QUESTION]->(q);

MERGE (o:AnswerOption {id: 'Q-TG-01-1'})
ON CREATE SET o.content = "180°",
              o.isCorrect = false
ON MATCH SET o.content = "180°",
             o.isCorrect = false
WITH o
MATCH (q:Question {id: 'Q-TG-01'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (o:AnswerOption {id: 'Q-TG-01-2'})
ON CREATE SET o.content = "270°",
              o.isCorrect = false
ON MATCH SET o.content = "270°",
             o.isCorrect = false
WITH o
MATCH (q:Question {id: 'Q-TG-01'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (o:AnswerOption {id: 'Q-TG-01-3'})
ON CREATE SET o.content = "360°",
              o.isCorrect = true
ON MATCH SET o.content = "360°",
             o.isCorrect = true
WITH o
MATCH (q:Question {id: 'Q-TG-01'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (o:AnswerOption {id: 'Q-TG-01-4'})
ON CREATE SET o.content = "540°",
              o.isCorrect = false
ON MATCH SET o.content = "540°",
             o.isCorrect = false
WITH o
MATCH (q:Question {id: 'Q-TG-01'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (q:Question {id: 'Q-TG-02'})
ON CREATE SET q.content = "Tứ giác ABCD có ∠A = 90°, ∠B = 80°, ∠C = 100°. Số đo ∠D là:",
              q.type = "CALCULATION",
              q.difficulty = 1,
              q.explanation = "Tổng bốn góc bằng 360°. ∠D = 360° − (90° + 80° + 100°) = 360° − 270° = 90°."
ON MATCH SET q.content = "Tứ giác ABCD có ∠A = 90°, ∠B = 80°, ∠C = 100°. Số đo ∠D là:",
             q.type = "CALCULATION",
             q.difficulty = 1,
             q.explanation = "Tổng bốn góc bằng 360°. ∠D = 360° − (90° + 80° + 100°) = 360° − 270° = 90°."
WITH q
MATCH (s:Shape {slug: 'tu-giac'})
MERGE (s)-[:HAS_QUESTION]->(q);

MERGE (o:AnswerOption {id: 'Q-TG-02-1'})
ON CREATE SET o.content = "80°",
              o.isCorrect = false
ON MATCH SET o.content = "80°",
             o.isCorrect = false
WITH o
MATCH (q:Question {id: 'Q-TG-02'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (o:AnswerOption {id: 'Q-TG-02-2'})
ON CREATE SET o.content = "90°",
              o.isCorrect = true
ON MATCH SET o.content = "90°",
             o.isCorrect = true
WITH o
MATCH (q:Question {id: 'Q-TG-02'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (o:AnswerOption {id: 'Q-TG-02-3'})
ON CREATE SET o.content = "100°",
              o.isCorrect = false
ON MATCH SET o.content = "100°",
             o.isCorrect = false
WITH o
MATCH (q:Question {id: 'Q-TG-02'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (o:AnswerOption {id: 'Q-TG-02-4'})
ON CREATE SET o.content = "110°",
              o.isCorrect = false
ON MATCH SET o.content = "110°",
             o.isCorrect = false
WITH o
MATCH (q:Question {id: 'Q-TG-02'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (q:Question {id: 'Q-TG-03'})
ON CREATE SET q.content = "Bốn góc ∠A, ∠B, ∠C, ∠D của một tứ giác tỉ lệ với 1 : 2 : 3 : 4. Số đo góc lớn nhất là:",
              q.type = "CALCULATION",
              q.difficulty = 2,
              q.explanation = "Tổng các phần là 1 + 2 + 3 + 4 = 10 phần, ứng với 360°. Mỗi phần là 36°. Góc lớn nhất là 4 × 36° = 144°."
ON MATCH SET q.content = "Bốn góc ∠A, ∠B, ∠C, ∠D của một tứ giác tỉ lệ với 1 : 2 : 3 : 4. Số đo góc lớn nhất là:",
             q.type = "CALCULATION",
             q.difficulty = 2,
             q.explanation = "Tổng các phần là 1 + 2 + 3 + 4 = 10 phần, ứng với 360°. Mỗi phần là 36°. Góc lớn nhất là 4 × 36° = 144°."
WITH q
MATCH (s:Shape {slug: 'tu-giac'})
MERGE (s)-[:HAS_QUESTION]->(q);

MERGE (o:AnswerOption {id: 'Q-TG-03-1'})
ON CREATE SET o.content = "120°",
              o.isCorrect = false
ON MATCH SET o.content = "120°",
             o.isCorrect = false
WITH o
MATCH (q:Question {id: 'Q-TG-03'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (o:AnswerOption {id: 'Q-TG-03-2'})
ON CREATE SET o.content = "144°",
              o.isCorrect = true
ON MATCH SET o.content = "144°",
             o.isCorrect = true
WITH o
MATCH (q:Question {id: 'Q-TG-03'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (o:AnswerOption {id: 'Q-TG-03-3'})
ON CREATE SET o.content = "150°",
              o.isCorrect = false
ON MATCH SET o.content = "150°",
             o.isCorrect = false
WITH o
MATCH (q:Question {id: 'Q-TG-03'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (o:AnswerOption {id: 'Q-TG-03-4'})
ON CREATE SET o.content = "160°",
              o.isCorrect = false
ON MATCH SET o.content = "160°",
             o.isCorrect = false
WITH o
MATCH (q:Question {id: 'Q-TG-03'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (q:Question {id: 'Q-TG-04'})
ON CREATE SET q.content = "Tứ giác ABCD có bao nhiêu đường chéo?",
              q.type = "THEORY",
              q.difficulty = 1,
              q.explanation = "Đường chéo là đoạn thẳng nối hai đỉnh không kề nhau. Tứ giác ABCD có hai đường chéo là AC và BD."
ON MATCH SET q.content = "Tứ giác ABCD có bao nhiêu đường chéo?",
             q.type = "THEORY",
             q.difficulty = 1,
             q.explanation = "Đường chéo là đoạn thẳng nối hai đỉnh không kề nhau. Tứ giác ABCD có hai đường chéo là AC và BD."
WITH q
MATCH (s:Shape {slug: 'tu-giac'})
MERGE (s)-[:HAS_QUESTION]->(q);

MERGE (o:AnswerOption {id: 'Q-TG-04-1'})
ON CREATE SET o.content = "1",
              o.isCorrect = false
ON MATCH SET o.content = "1",
             o.isCorrect = false
WITH o
MATCH (q:Question {id: 'Q-TG-04'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (o:AnswerOption {id: 'Q-TG-04-2'})
ON CREATE SET o.content = "2",
              o.isCorrect = true
ON MATCH SET o.content = "2",
             o.isCorrect = true
WITH o
MATCH (q:Question {id: 'Q-TG-04'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (o:AnswerOption {id: 'Q-TG-04-3'})
ON CREATE SET o.content = "3",
              o.isCorrect = false
ON MATCH SET o.content = "3",
             o.isCorrect = false
WITH o
MATCH (q:Question {id: 'Q-TG-04'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (o:AnswerOption {id: 'Q-TG-04-4'})
ON CREATE SET o.content = "4",
              o.isCorrect = false
ON MATCH SET o.content = "4",
             o.isCorrect = false
WITH o
MATCH (q:Question {id: 'Q-TG-04'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (q:Question {id: 'Q-TG-05'})
ON CREATE SET q.content = "Cho bốn điểm A, B, C, D trong đó ba điểm A, B, C thẳng hàng. Nối AB, BC, CD, DA có tạo thành tứ giác ABCD không?",
              q.type = "RECOGNITION",
              q.difficulty = 2,
              q.explanation = "Theo định nghĩa, trong tứ giác không có ba đỉnh liên tiếp nào thẳng hàng. Vì A, B, C thẳng hàng nên hình này không phải tứ giác."
ON MATCH SET q.content = "Cho bốn điểm A, B, C, D trong đó ba điểm A, B, C thẳng hàng. Nối AB, BC, CD, DA có tạo thành tứ giác ABCD không?",
             q.type = "RECOGNITION",
             q.difficulty = 2,
             q.explanation = "Theo định nghĩa, trong tứ giác không có ba đỉnh liên tiếp nào thẳng hàng. Vì A, B, C thẳng hàng nên hình này không phải tứ giác."
WITH q
MATCH (s:Shape {slug: 'tu-giac'})
MERGE (s)-[:HAS_QUESTION]->(q);

MERGE (o:AnswerOption {id: 'Q-TG-05-1'})
ON CREATE SET o.content = "Có, vì có bốn đoạn thẳng nối tiếp nhau",
              o.isCorrect = false
ON MATCH SET o.content = "Có, vì có bốn đoạn thẳng nối tiếp nhau",
             o.isCorrect = false
WITH o
MATCH (q:Question {id: 'Q-TG-05'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (o:AnswerOption {id: 'Q-TG-05-2'})
ON CREATE SET o.content = "Không, vì ba đỉnh liên tiếp A, B, C thẳng hàng",
              o.isCorrect = true
ON MATCH SET o.content = "Không, vì ba đỉnh liên tiếp A, B, C thẳng hàng",
             o.isCorrect = true
WITH o
MATCH (q:Question {id: 'Q-TG-05'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (o:AnswerOption {id: 'Q-TG-05-3'})
ON CREATE SET o.content = "Có, vì tổng các góc bằng 360°",
              o.isCorrect = false
ON MATCH SET o.content = "Có, vì tổng các góc bằng 360°",
             o.isCorrect = false
WITH o
MATCH (q:Question {id: 'Q-TG-05'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (o:AnswerOption {id: 'Q-TG-05-4'})
ON CREATE SET o.content = "Không, vì D không nằm trên đường thẳng AB",
              o.isCorrect = false
ON MATCH SET o.content = "Không, vì D không nằm trên đường thẳng AB",
             o.isCorrect = false
WITH o
MATCH (q:Question {id: 'Q-TG-05'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (q:Question {id: 'Q-THOI-01'})
ON CREATE SET q.content = "Hình thoi là tứ giác có:",
              q.type = "THEORY",
              q.difficulty = 1,
              q.explanation = "Định nghĩa: hình thoi là tứ giác có bốn cạnh bằng nhau."
ON MATCH SET q.content = "Hình thoi là tứ giác có:",
             q.type = "THEORY",
             q.difficulty = 1,
             q.explanation = "Định nghĩa: hình thoi là tứ giác có bốn cạnh bằng nhau."
WITH q
MATCH (s:Shape {slug: 'hinh-thoi'})
MERGE (s)-[:HAS_QUESTION]->(q);

MERGE (o:AnswerOption {id: 'Q-THOI-01-1'})
ON CREATE SET o.content = "Bốn góc vuông",
              o.isCorrect = false
ON MATCH SET o.content = "Bốn góc vuông",
             o.isCorrect = false
WITH o
MATCH (q:Question {id: 'Q-THOI-01'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (o:AnswerOption {id: 'Q-THOI-01-2'})
ON CREATE SET o.content = "Bốn cạnh bằng nhau",
              o.isCorrect = true
ON MATCH SET o.content = "Bốn cạnh bằng nhau",
             o.isCorrect = true
WITH o
MATCH (q:Question {id: 'Q-THOI-01'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (o:AnswerOption {id: 'Q-THOI-01-3'})
ON CREATE SET o.content = "Hai cạnh kề bằng nhau",
              o.isCorrect = false
ON MATCH SET o.content = "Hai cạnh kề bằng nhau",
             o.isCorrect = false
WITH o
MATCH (q:Question {id: 'Q-THOI-01'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (o:AnswerOption {id: 'Q-THOI-01-4'})
ON CREATE SET o.content = "Hai đường chéo bằng nhau",
              o.isCorrect = false
ON MATCH SET o.content = "Hai đường chéo bằng nhau",
             o.isCorrect = false
WITH o
MATCH (q:Question {id: 'Q-THOI-01'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (q:Question {id: 'Q-THOI-02'})
ON CREATE SET q.content = "Trong hình thoi, hai đường chéo:",
              q.type = "THEORY",
              q.difficulty = 2,
              q.explanation = "Tính chất của hình thoi: hai đường chéo vuông góc với nhau và là các đường phân giác của các góc của hình thoi."
ON MATCH SET q.content = "Trong hình thoi, hai đường chéo:",
             q.type = "THEORY",
             q.difficulty = 2,
             q.explanation = "Tính chất của hình thoi: hai đường chéo vuông góc với nhau và là các đường phân giác của các góc của hình thoi."
WITH q
MATCH (s:Shape {slug: 'hinh-thoi'})
MERGE (s)-[:HAS_QUESTION]->(q);

MERGE (o:AnswerOption {id: 'Q-THOI-02-1'})
ON CREATE SET o.content = "Bằng nhau",
              o.isCorrect = false
ON MATCH SET o.content = "Bằng nhau",
             o.isCorrect = false
WITH o
MATCH (q:Question {id: 'Q-THOI-02'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (o:AnswerOption {id: 'Q-THOI-02-2'})
ON CREATE SET o.content = "Vuông góc với nhau và là đường phân giác của các góc",
              o.isCorrect = true
ON MATCH SET o.content = "Vuông góc với nhau và là đường phân giác của các góc",
             o.isCorrect = true
WITH o
MATCH (q:Question {id: 'Q-THOI-02'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (o:AnswerOption {id: 'Q-THOI-02-3'})
ON CREATE SET o.content = "Song song với nhau",
              o.isCorrect = false
ON MATCH SET o.content = "Song song với nhau",
             o.isCorrect = false
WITH o
MATCH (q:Question {id: 'Q-THOI-02'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (o:AnswerOption {id: 'Q-THOI-02-4'})
ON CREATE SET o.content = "Chỉ vuông góc, không là đường phân giác",
              o.isCorrect = false
ON MATCH SET o.content = "Chỉ vuông góc, không là đường phân giác",
             o.isCorrect = false
WITH o
MATCH (q:Question {id: 'Q-THOI-02'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (q:Question {id: 'Q-THOI-03'})
ON CREATE SET q.content = "Hình thoi có hai đường chéo dài 6 cm và 8 cm. Độ dài cạnh hình thoi là:",
              q.type = "CALCULATION",
              q.difficulty = 2,
              q.explanation = "Hai đường chéo vuông góc và cắt nhau tại trung điểm nên cạnh là cạnh huyền của tam giác vuông có hai cạnh góc vuông 3 cm và 4 cm: √(3² + 4²) = 5 cm."
ON MATCH SET q.content = "Hình thoi có hai đường chéo dài 6 cm và 8 cm. Độ dài cạnh hình thoi là:",
             q.type = "CALCULATION",
             q.difficulty = 2,
             q.explanation = "Hai đường chéo vuông góc và cắt nhau tại trung điểm nên cạnh là cạnh huyền của tam giác vuông có hai cạnh góc vuông 3 cm và 4 cm: √(3² + 4²) = 5 cm."
WITH q
MATCH (s:Shape {slug: 'hinh-thoi'})
MERGE (s)-[:HAS_QUESTION]->(q);

MERGE (o:AnswerOption {id: 'Q-THOI-03-1'})
ON CREATE SET o.content = "5 cm",
              o.isCorrect = true
ON MATCH SET o.content = "5 cm",
             o.isCorrect = true
WITH o
MATCH (q:Question {id: 'Q-THOI-03'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (o:AnswerOption {id: 'Q-THOI-03-2'})
ON CREATE SET o.content = "7 cm",
              o.isCorrect = false
ON MATCH SET o.content = "7 cm",
             o.isCorrect = false
WITH o
MATCH (q:Question {id: 'Q-THOI-03'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (o:AnswerOption {id: 'Q-THOI-03-3'})
ON CREATE SET o.content = "10 cm",
              o.isCorrect = false
ON MATCH SET o.content = "10 cm",
             o.isCorrect = false
WITH o
MATCH (q:Question {id: 'Q-THOI-03'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (o:AnswerOption {id: 'Q-THOI-03-4'})
ON CREATE SET o.content = "14 cm",
              o.isCorrect = false
ON MATCH SET o.content = "14 cm",
             o.isCorrect = false
WITH o
MATCH (q:Question {id: 'Q-THOI-03'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (q:Question {id: 'Q-THOI-04'})
ON CREATE SET q.content = "Hình thoi có hai đường chéo dài 10 cm và 24 cm. Diện tích hình thoi là:",
              q.type = "CALCULATION",
              q.difficulty = 1,
              q.explanation = "S = d₁ · d₂ / 2 = 10 · 24 / 2 = 120 cm²."
ON MATCH SET q.content = "Hình thoi có hai đường chéo dài 10 cm và 24 cm. Diện tích hình thoi là:",
             q.type = "CALCULATION",
             q.difficulty = 1,
             q.explanation = "S = d₁ · d₂ / 2 = 10 · 24 / 2 = 120 cm²."
WITH q
MATCH (s:Shape {slug: 'hinh-thoi'})
MERGE (s)-[:HAS_QUESTION]->(q);

MERGE (o:AnswerOption {id: 'Q-THOI-04-1'})
ON CREATE SET o.content = "120 cm²",
              o.isCorrect = true
ON MATCH SET o.content = "120 cm²",
             o.isCorrect = true
WITH o
MATCH (q:Question {id: 'Q-THOI-04'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (o:AnswerOption {id: 'Q-THOI-04-2'})
ON CREATE SET o.content = "240 cm²",
              o.isCorrect = false
ON MATCH SET o.content = "240 cm²",
             o.isCorrect = false
WITH o
MATCH (q:Question {id: 'Q-THOI-04'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (o:AnswerOption {id: 'Q-THOI-04-3'})
ON CREATE SET o.content = "34 cm²",
              o.isCorrect = false
ON MATCH SET o.content = "34 cm²",
             o.isCorrect = false
WITH o
MATCH (q:Question {id: 'Q-THOI-04'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (o:AnswerOption {id: 'Q-THOI-04-4'})
ON CREATE SET o.content = "60 cm²",
              o.isCorrect = false
ON MATCH SET o.content = "60 cm²",
             o.isCorrect = false
WITH o
MATCH (q:Question {id: 'Q-THOI-04'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (q:Question {id: 'Q-THOI-05'})
ON CREATE SET q.content = "Hình bình hành có thêm điều kiện nào dưới đây thì là hình thoi?",
              q.type = "RECOGNITION",
              q.difficulty = 2,
              q.explanation = "Hình bình hành có hai cạnh kề bằng nhau là hình thoi. Hai đường chéo bằng nhau hoặc có một góc vuông thì là hình chữ nhật. Hai cạnh đối bằng nhau thì hình bình hành nào cũng có."
ON MATCH SET q.content = "Hình bình hành có thêm điều kiện nào dưới đây thì là hình thoi?",
             q.type = "RECOGNITION",
             q.difficulty = 2,
             q.explanation = "Hình bình hành có hai cạnh kề bằng nhau là hình thoi. Hai đường chéo bằng nhau hoặc có một góc vuông thì là hình chữ nhật. Hai cạnh đối bằng nhau thì hình bình hành nào cũng có."
WITH q
MATCH (s:Shape {slug: 'hinh-thoi'})
MERGE (s)-[:HAS_QUESTION]->(q);

MERGE (o:AnswerOption {id: 'Q-THOI-05-1'})
ON CREATE SET o.content = "Hai cạnh kề bằng nhau",
              o.isCorrect = true
ON MATCH SET o.content = "Hai cạnh kề bằng nhau",
             o.isCorrect = true
WITH o
MATCH (q:Question {id: 'Q-THOI-05'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (o:AnswerOption {id: 'Q-THOI-05-2'})
ON CREATE SET o.content = "Hai đường chéo bằng nhau",
              o.isCorrect = false
ON MATCH SET o.content = "Hai đường chéo bằng nhau",
             o.isCorrect = false
WITH o
MATCH (q:Question {id: 'Q-THOI-05'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (o:AnswerOption {id: 'Q-THOI-05-3'})
ON CREATE SET o.content = "Có một góc vuông",
              o.isCorrect = false
ON MATCH SET o.content = "Có một góc vuông",
             o.isCorrect = false
WITH o
MATCH (q:Question {id: 'Q-THOI-05'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (o:AnswerOption {id: 'Q-THOI-05-4'})
ON CREATE SET o.content = "Hai cạnh đối bằng nhau",
              o.isCorrect = false
ON MATCH SET o.content = "Hai cạnh đối bằng nhau",
             o.isCorrect = false
WITH o
MATCH (q:Question {id: 'Q-THOI-05'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (q:Question {id: 'Q-VUONG-01'})
ON CREATE SET q.content = "Hình vuông là tứ giác có:",
              q.type = "THEORY",
              q.difficulty = 1,
              q.explanation = "Định nghĩa: hình vuông là tứ giác có bốn góc vuông và bốn cạnh bằng nhau."
ON MATCH SET q.content = "Hình vuông là tứ giác có:",
             q.type = "THEORY",
             q.difficulty = 1,
             q.explanation = "Định nghĩa: hình vuông là tứ giác có bốn góc vuông và bốn cạnh bằng nhau."
WITH q
MATCH (s:Shape {slug: 'hinh-vuong'})
MERGE (s)-[:HAS_QUESTION]->(q);

MERGE (o:AnswerOption {id: 'Q-VUONG-01-1'})
ON CREATE SET o.content = "Bốn cạnh bằng nhau",
              o.isCorrect = false
ON MATCH SET o.content = "Bốn cạnh bằng nhau",
             o.isCorrect = false
WITH o
MATCH (q:Question {id: 'Q-VUONG-01'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (o:AnswerOption {id: 'Q-VUONG-01-2'})
ON CREATE SET o.content = "Bốn góc vuông",
              o.isCorrect = false
ON MATCH SET o.content = "Bốn góc vuông",
             o.isCorrect = false
WITH o
MATCH (q:Question {id: 'Q-VUONG-01'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (o:AnswerOption {id: 'Q-VUONG-01-3'})
ON CREATE SET o.content = "Bốn góc vuông và bốn cạnh bằng nhau",
              o.isCorrect = true
ON MATCH SET o.content = "Bốn góc vuông và bốn cạnh bằng nhau",
             o.isCorrect = true
WITH o
MATCH (q:Question {id: 'Q-VUONG-01'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (o:AnswerOption {id: 'Q-VUONG-01-4'})
ON CREATE SET o.content = "Hai đường chéo bằng nhau",
              o.isCorrect = false
ON MATCH SET o.content = "Hai đường chéo bằng nhau",
             o.isCorrect = false
WITH o
MATCH (q:Question {id: 'Q-VUONG-01'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (q:Question {id: 'Q-VUONG-02'})
ON CREATE SET q.content = "Khẳng định nào sau đây đúng?",
              q.type = "THEORY",
              q.difficulty = 2,
              q.explanation = "Hình vuông có bốn góc vuông nên là hình chữ nhật. Chiều ngược lại không đúng: hình chữ nhật có hai cạnh kề khác nhau thì không phải hình vuông."
ON MATCH SET q.content = "Khẳng định nào sau đây đúng?",
             q.type = "THEORY",
             q.difficulty = 2,
             q.explanation = "Hình vuông có bốn góc vuông nên là hình chữ nhật. Chiều ngược lại không đúng: hình chữ nhật có hai cạnh kề khác nhau thì không phải hình vuông."
WITH q
MATCH (s:Shape {slug: 'hinh-vuong'})
MERGE (s)-[:HAS_QUESTION]->(q);

MERGE (o:AnswerOption {id: 'Q-VUONG-02-1'})
ON CREATE SET o.content = "Mọi hình chữ nhật đều là hình vuông",
              o.isCorrect = false
ON MATCH SET o.content = "Mọi hình chữ nhật đều là hình vuông",
             o.isCorrect = false
WITH o
MATCH (q:Question {id: 'Q-VUONG-02'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (o:AnswerOption {id: 'Q-VUONG-02-2'})
ON CREATE SET o.content = "Mọi hình vuông đều là hình chữ nhật",
              o.isCorrect = true
ON MATCH SET o.content = "Mọi hình vuông đều là hình chữ nhật",
             o.isCorrect = true
WITH o
MATCH (q:Question {id: 'Q-VUONG-02'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (o:AnswerOption {id: 'Q-VUONG-02-3'})
ON CREATE SET o.content = "Mọi hình thoi đều là hình vuông",
              o.isCorrect = false
ON MATCH SET o.content = "Mọi hình thoi đều là hình vuông",
             o.isCorrect = false
WITH o
MATCH (q:Question {id: 'Q-VUONG-02'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (o:AnswerOption {id: 'Q-VUONG-02-4'})
ON CREATE SET o.content = "Mọi hình bình hành đều là hình vuông",
              o.isCorrect = false
ON MATCH SET o.content = "Mọi hình bình hành đều là hình vuông",
             o.isCorrect = false
WITH o
MATCH (q:Question {id: 'Q-VUONG-02'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (q:Question {id: 'Q-VUONG-03'})
ON CREATE SET q.content = "Hình vuông có cạnh 9 cm. Chu vi hình vuông là:",
              q.type = "CALCULATION",
              q.difficulty = 1,
              q.explanation = "P = 4a = 4 · 9 = 36 cm."
ON MATCH SET q.content = "Hình vuông có cạnh 9 cm. Chu vi hình vuông là:",
             q.type = "CALCULATION",
             q.difficulty = 1,
             q.explanation = "P = 4a = 4 · 9 = 36 cm."
WITH q
MATCH (s:Shape {slug: 'hinh-vuong'})
MERGE (s)-[:HAS_QUESTION]->(q);

MERGE (o:AnswerOption {id: 'Q-VUONG-03-1'})
ON CREATE SET o.content = "18 cm",
              o.isCorrect = false
ON MATCH SET o.content = "18 cm",
             o.isCorrect = false
WITH o
MATCH (q:Question {id: 'Q-VUONG-03'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (o:AnswerOption {id: 'Q-VUONG-03-2'})
ON CREATE SET o.content = "27 cm",
              o.isCorrect = false
ON MATCH SET o.content = "27 cm",
             o.isCorrect = false
WITH o
MATCH (q:Question {id: 'Q-VUONG-03'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (o:AnswerOption {id: 'Q-VUONG-03-3'})
ON CREATE SET o.content = "36 cm",
              o.isCorrect = true
ON MATCH SET o.content = "36 cm",
             o.isCorrect = true
WITH o
MATCH (q:Question {id: 'Q-VUONG-03'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (o:AnswerOption {id: 'Q-VUONG-03-4'})
ON CREATE SET o.content = "81 cm",
              o.isCorrect = false
ON MATCH SET o.content = "81 cm",
             o.isCorrect = false
WITH o
MATCH (q:Question {id: 'Q-VUONG-03'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (q:Question {id: 'Q-VUONG-04'})
ON CREATE SET q.content = "Hình vuông có cạnh 6 cm. Độ dài đường chéo là:",
              q.type = "CALCULATION",
              q.difficulty = 2,
              q.explanation = "Đường chéo d = a√2 = 6√2 cm (khoảng 8,49 cm), theo định lý Pythagore: d² = 6² + 6² = 72."
ON MATCH SET q.content = "Hình vuông có cạnh 6 cm. Độ dài đường chéo là:",
             q.type = "CALCULATION",
             q.difficulty = 2,
             q.explanation = "Đường chéo d = a√2 = 6√2 cm (khoảng 8,49 cm), theo định lý Pythagore: d² = 6² + 6² = 72."
WITH q
MATCH (s:Shape {slug: 'hinh-vuong'})
MERGE (s)-[:HAS_QUESTION]->(q);

MERGE (o:AnswerOption {id: 'Q-VUONG-04-1'})
ON CREATE SET o.content = "6√2 cm",
              o.isCorrect = true
ON MATCH SET o.content = "6√2 cm",
             o.isCorrect = true
WITH o
MATCH (q:Question {id: 'Q-VUONG-04'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (o:AnswerOption {id: 'Q-VUONG-04-2'})
ON CREATE SET o.content = "12 cm",
              o.isCorrect = false
ON MATCH SET o.content = "12 cm",
             o.isCorrect = false
WITH o
MATCH (q:Question {id: 'Q-VUONG-04'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (o:AnswerOption {id: 'Q-VUONG-04-3'})
ON CREATE SET o.content = "6 cm",
              o.isCorrect = false
ON MATCH SET o.content = "6 cm",
             o.isCorrect = false
WITH o
MATCH (q:Question {id: 'Q-VUONG-04'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (o:AnswerOption {id: 'Q-VUONG-04-4'})
ON CREATE SET o.content = "36 cm",
              o.isCorrect = false
ON MATCH SET o.content = "36 cm",
             o.isCorrect = false
WITH o
MATCH (q:Question {id: 'Q-VUONG-04'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (q:Question {id: 'Q-VUONG-05'})
ON CREATE SET q.content = "Hình chữ nhật cần thêm điều kiện nào dưới đây để trở thành hình vuông?",
              q.type = "RECOGNITION",
              q.difficulty = 1,
              q.explanation = "Hình chữ nhật có hai cạnh kề bằng nhau là hình vuông. Hai đường chéo bằng nhau, hai cạnh đối bằng nhau và có một góc vuông đều đã đúng với mọi hình chữ nhật."
ON MATCH SET q.content = "Hình chữ nhật cần thêm điều kiện nào dưới đây để trở thành hình vuông?",
             q.type = "RECOGNITION",
             q.difficulty = 1,
             q.explanation = "Hình chữ nhật có hai cạnh kề bằng nhau là hình vuông. Hai đường chéo bằng nhau, hai cạnh đối bằng nhau và có một góc vuông đều đã đúng với mọi hình chữ nhật."
WITH q
MATCH (s:Shape {slug: 'hinh-vuong'})
MERGE (s)-[:HAS_QUESTION]->(q);

MERGE (o:AnswerOption {id: 'Q-VUONG-05-1'})
ON CREATE SET o.content = "Hai cạnh kề bằng nhau",
              o.isCorrect = true
ON MATCH SET o.content = "Hai cạnh kề bằng nhau",
             o.isCorrect = true
WITH o
MATCH (q:Question {id: 'Q-VUONG-05'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (o:AnswerOption {id: 'Q-VUONG-05-2'})
ON CREATE SET o.content = "Hai đường chéo bằng nhau",
              o.isCorrect = false
ON MATCH SET o.content = "Hai đường chéo bằng nhau",
             o.isCorrect = false
WITH o
MATCH (q:Question {id: 'Q-VUONG-05'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (o:AnswerOption {id: 'Q-VUONG-05-3'})
ON CREATE SET o.content = "Hai cạnh đối bằng nhau",
              o.isCorrect = false
ON MATCH SET o.content = "Hai cạnh đối bằng nhau",
             o.isCorrect = false
WITH o
MATCH (q:Question {id: 'Q-VUONG-05'})
MERGE (q)-[:HAS_OPTION]->(o);

MERGE (o:AnswerOption {id: 'Q-VUONG-05-4'})
ON CREATE SET o.content = "Có một góc vuông",
              o.isCorrect = false
ON MATCH SET o.content = "Có một góc vuông",
             o.isCorrect = false
WITH o
MATCH (q:Question {id: 'Q-VUONG-05'})
MERGE (q)-[:HAS_OPTION]->(o);
