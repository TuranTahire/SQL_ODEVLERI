🛍️ E-Ticaret Platformu Veritabanı Projesi
Bu proje, bir online alışveriş platformunun (e-ticaret) temel iş süreçlerini yönetmek üzere tasarlanmış İlişkisel Veritabanı Yönetim Sistemi'nin (RDBMS) oluşturulmasını, veri manipülasyonunu ve ileri düzey raporlamasını içerir.

🛠️ Proje Mimarisi ve Teknoloji
Veritabanı Motoru: Microsoft SQL Server (MSSQL)

Programlama Dili: Transact-SQL (T-SQL)

Tasarım Prensibi: Üçüncü Normal Form (3NF)

1. Varlık İlişki Diyagramı (ERD)
Tasarım, veri bütünlüğünü sağlamak ve veri tekrarını önlemek için 6 temel tablodan oluşur. İlişkilerin çoğu, Yabancı Anahtarlar (Foreign Keys) ile kurulmuştur.

Temel İlişkiler
Çoktan Çoğa (N:M): Siparis ve Urun arasındaki ilişki, Siparis_Detay tablosu ile çözülmüştür.

Bire Çoğa (1:N): Musteri → Siparis ve Kategori/Satici → Urun.

2. SQL Script Dosyası (Database Setup)
e_ticaret_projesi_script.sql dosyası, veritabanını sıfırdan kurmak ve çalıştırmak için gereken tüm komutları içerir.

A. DDL: Tablo Oluşturma (CREATE)
Tablolar, MSSQL'e özel IDENTITY(1,1) yapısı kullanılarak otomatik artan anahtarlarla tanımlanmıştır. Tüm kritik ilişkiler (FOREIGN KEY) tanımlanmıştır.

B. DML: Veri Ekleme ve Yönetimi (INSERT, UPDATE, DELETE, TRUNCATE)
Veri Bütünlüğü Yönetimi (Kritik Çözümler)
Veritabanı bütünlüğünü korumak amacıyla DELETE ve TRUNCATE işlemleri özel bir sırayla yapılmıştır:

Sipariş Temizliği: Önce Siparis_Detay, sonra Siparis silinmiştir.

TRUNCATE Çözümü: TRUNCATE TABLE Satici; komutu, Urun tablosundan referans aldığı için başlangıçta hata vermiştir. Bu hata, TRUNCATE işleminden hemen önce DELETE FROM Urun; komutunun çalıştırılmasıyla aşılmıştır. (Yani, Satici silinmeden önce tüm ürünler silinmiştir.)

3. Raporlama Sorguları (Analiz Çıktıları)
Projenin en önemli kısmı olan analiz sorguları, veritabanının sorgulama yeteneğini gösterir.

Temel Raporlar
Kategori	Sorgu Açıklaması	SQL Anahtar Kelimeleri
Sıralama	En çok sipariş veren ilk 5 müşteri.	GROUP BY, COUNT(), ORDER BY, TOP 5
Gruplama	Şehirlere göre müşteri sayısı ve kategori bazlı toplam satış.	GROUP BY, SUM()
Aylık Analiz	Aylara göre sipariş sayısı.	FORMAT(tarih, 'yyyy-MM')

İleri Düzey Analitik Sorgular
Sorgu Adı	Açıklama	Ana Teknik
Ortalama Üstü Siparişler	Ortalama sipariş tutarını geçen siparişleri listeler.	Alt Sorgu (Subquery) ve AVG()
Satın Alım Geçmişi	En az bir kez 'Elektronik' ürün satın alan müşteriler.	INNER JOIN, Alt Sorgu (Subquery)
Pasif Müşteriler	Hiç sipariş vermemiş müşteriler.	LEFT JOIN ve WHERE IS NULL

4. Dokümantasyon ve Sorun Giderme Özeti
Aşama	Karşılaşılan Kritik Hata	Nasıl Çözüldü?
Kurulum	Incorrect syntax near 'AUTO_INCREMENT'.	IDENTITY(1,1) ile MSSQL uyumluluğu sağlandı.
Tarih Formatı	'STRFTIME' is not a recognized built-in function name.	SQL Server'a özel FORMAT() fonksiyonu kullanıldı.
Veri Bütünlüğü	Cannot truncate table 'Satici' because it is being referenced by a FOREIGN KEY...	TRUNCATE işleminden önce bağımlı olan Urun tablosundaki tüm veriler DELETE ile temizlenerek kısıtlama aşıldı.
Çalıştırma	Database 'Eticaret_db' already exists.	Tüm komutlar, var olan veritabanını kullanan USE Eticaret_db; ve temizlik (DROP TABLE) komutları ile yeniden yapılandırıldı