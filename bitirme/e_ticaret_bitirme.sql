--CREATE DATABASE Eticaret_db;
USE Eticaret_db;
GO


IF OBJECT_ID('Siparis_Detay') IS NOT NULL DROP TABLE Siparis_Detay;
IF OBJECT_ID('Siparis') IS NOT NULL DROP TABLE Siparis;
IF OBJECT_ID('Urun') IS NOT NULL DROP TABLE Urun;
IF OBJECT_ID('Musteri') IS NOT NULL DROP TABLE Musteri;
IF OBJECT_ID('Satici') IS NOT NULL DROP TABLE Satici;
IF OBJECT_ID('Kategori') IS NOT NULL DROP TABLE Kategori;
GO

-- 2. TABLO OLUÞTURMA (DDL - PART A)

CREATE TABLE Kategori (
 id INT PRIMARY KEY IDENTITY(1,1),
 ad NVARCHAR (100) NOT NULL UNIQUE
 );

 CREATE TABLE Satici (
  id INT PRIMARY KEY IDENTITY(1,1),
  ad NVARCHAR (255) NOT NULL,
  adres NVARCHAR(500)
 );

 CREATE TABLE Musteri(
  id INT PRIMARY KEY IDENTITY(1,1),
  ad NVARCHAR(100) NOT NULL,
  soyad NVARCHAR(255) NOT NULL, 
  email NVARCHAR(255) NOT NULL UNIQUE,
  sehir VARCHAR(100),
  kayit_tarihi DATE NOT NULL
  );

CREATE TABLE Urun (
    id INT PRIMARY KEY IDENTITY (1,1),
    ad VARCHAR(255) NOT NULL,
    fiyat DECIMAL(10, 2) NOT NULL,
    stok INT NOT NULL,
    kategori_id INT,
    satici_id INT,
    FOREIGN KEY (kategori_id) REFERENCES Kategori(id),
    FOREIGN KEY (satici_id) REFERENCES Satici(id)
);


CREATE TABLE Siparis (
    id INT PRIMARY KEY IDENTITY (1,1),
    musteri_id INT NOT NULL,
    tarih DATE NOT NULL,
    toplam_tutar DECIMAL(10, 2) NOT NULL,
    odeme_turu VARCHAR(50),
    FOREIGN KEY (musteri_id) REFERENCES Musteri(id)
);

CREATE TABLE Siparis_Detay (
    id INT PRIMARY KEY IDENTITY(1,1),
    siparis_id INT NOT NULL,
    urun_id INT NOT NULL,
    adet INT NOT NULL,
    fiyat DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (siparis_id) REFERENCES Siparis(id),
    FOREIGN KEY (urun_id) REFERENCES Urun(id)
);
GO

-- 3. VERÝ EKLEME VE YÖNETÝMÝ (DML - PART B)

-- INSERT Komutlarý
INSERT INTO Kategori (ad) VALUES ('Elektronik'), ('Giyim'), ('Kitap');
INSERT INTO Satici (ad, adres) VALUES ('Biliþim A.Þ.', 'Ýstanbul, Teknopark'), ('Moda Dünyasý', 'Ýzmir, Konak'), ('Kitap Kurdu Yayýnevi', 'Ankara, Kýzýlay');
INSERT INTO Musteri (ad, soyad, email, sehir, kayit_tarihi) VALUES
('Ayþe', 'Yýlmaz', 'ayse@mail.com', 'Ýstanbul', '2024-01-15'),
('Burak', 'Kaya', 'burak@mail.com', 'Ankara', '2024-02-28'),
('Ceren', 'Demir', 'ceren@mail.com', 'Ýzmir', '2024-03-10'),
('Deniz', 'Öztürk', 'deniz@mail.com', 'Ýstanbul', '2024-04-01');
INSERT INTO Urun (ad, fiyat, stok, kategori_id, satici_id) VALUES
('Akýllý Telefon X', 15000.00, 50, 1, 1),    
('Yazlýk Elbise', 850.00, 120, 2, 2),       
('SQL Öðrenme Kitabý', 250.50, 200, 3, 3),    
('Kablosuz Kulaklýk', 1200.00, 40, 1, 1),   
('Kýþlýk Mont', 1500.00, 60, 2, 2);         
INSERT INTO Siparis (musteri_id, tarih, toplam_tutar, odeme_turu) VALUES
(1, '2024-05-01', 15250.50, 'Kredi Kartý'), 
(2, '2024-05-03', 1200.00, 'EFT'),          
(3, '2024-05-05', 3000.00, 'Kapýda Ödeme'),  
(1, '2024-05-10', 850.00, 'Kredi Kartý');    
INSERT INTO Siparis_Detay (siparis_id, urun_id, adet, fiyat) VALUES
(1, 1, 1, 15000.00), 
(1, 3, 1, 250.50),  
(2, 4, 1, 1200.00),  
(3, 5, 2, 1500.00),  
(4, 2, 1, 850.00);  

-- UPDATE Komutlarý
UPDATE Urun SET stok = stok-1 WHERE id = (SELECT urun_id FROM Siparis_Detay WHERE id=2);
UPDATE Urun SET fiyat = fiyat* 1.10 WHERE kategori_id =(SELECT id FROM Kategori WHERE ad = 'Kitap' );
UPDATE Musteri SET sehir = 'Ankara' WHERE email = 'deniz@mail.com';

-- DELETE Komutlarý (Sipariþ 4 ve Detaylarýnýn Silinmesi)
DELETE FROM Siparis_Detay WHERE siparis_id = 4;
DELETE FROM Siparis WHERE id = 4;

DELETE FROM Siparis_Detay;
DELETE FROM Urun;


-- Artýk Urun tablosunda Satici FK'sýna referans kalmadýðý için TRUNCATE çalýþýr.
TRUNCATE TABLE Satici;
GO

-- 4. RAPORLAMA SORGULARI (SELECT - PART C & D)

-- Temel Raporlar
SELECT TOP 5 musteri_id, COUNT(id) AS Siparis_Sayisi FROM Siparis GROUP BY musteri_id ORDER BY Siparis_Sayisi DESC;
SELECT T2.ad AS Urun_Adi, SUM(T1.adet) AS Toplam_Satilan_Adet FROM Siparis_Detay T1 INNER JOIN Urun T2 ON T1.urun_id = T2.id GROUP BY T2.ad ORDER BY Toplam_Satilan_Adet DESC;
SELECT T3.ad AS Satici_Adi, SUM(T1.adet * T1.fiyat) AS Toplam_Ciro FROM Siparis_Detay T1 INNER JOIN Urun T2 ON T1.urun_id = T2.id INNER JOIN Satici T3 ON T2.satici_id = T3.id GROUP BY T3.ad ORDER BY Toplam_Ciro DESC;

-- Gruplama ve Hesaplama Raporlarý
SELECT sehir, COUNT(id) AS Musteri_Sayisi FROM Musteri GROUP BY sehir ORDER BY Musteri_Sayisi DESC;
SELECT T3.ad AS Kategori_Adi, SUM(T1.adet * T1.fiyat) AS Kategori_Toplam_Satis FROM Siparis_Detay T1 INNER JOIN Urun T2 ON T1.urun_id = T2.id INNER JOIN Kategori T3 ON T2.kategori_id = T3.id GROUP BY T3.ad ORDER BY Kategori_Toplam_Satis DESC;
SELECT FORMAT(tarih, 'yyyy-MM') AS Siparis_Ay, COUNT(id) AS Siparis_Adedi FROM Siparis GROUP BY FORMAT(tarih, 'yyyy-MM') ORDER BY Siparis_Ay;

-- Ýleri Düzey JOIN Raporlarý
SELECT T1.ad, T1.soyad, T1.email FROM Musteri T1 LEFT JOIN Siparis T2 ON T1.id = T2.musteri_id WHERE T2.musteri_id IS NULL; -- Hiç sipariþ vermemiþ müþteriler.
SELECT TOP 3 T3.ad AS Kategori_Adi, SUM(T1.adet * T1.fiyat) AS Toplam_Ciro FROM Siparis_Detay T1 INNER JOIN Urun T2 ON T1.urun_id = T2.id INNER JOIN Kategori T3 ON T2.kategori_id = T3.id GROUP BY T3.ad ORDER BY Toplam_Ciro DESC;
SELECT id AS Siparis_ID, musteri_id, toplam_tutar FROM Siparis WHERE toplam_tutar > (SELECT AVG(toplam_tutar) FROM Siparis) ORDER BY toplam_tutar DESC;
SELECT DISTINCT T1.ad, T1.soyad, T1.email FROM Musteri T1 INNER JOIN Siparis T2 ON T1.id = T2.musteri_id INNER JOIN Siparis_Detay T3 ON T2.id = T3.siparis_id INNER JOIN Urun T4 ON T3.urun_id = T4.id WHERE T4.kategori_id = (SELECT id FROM Kategori WHERE ad = 'Elektronik');
GO