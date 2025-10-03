--CREATE DATABASE PERSONEL 

USE PERSONEL;
GO

IF OBJECT_ID('KULLANICILAR','U') IS NULL
CREATE TABLE KULLANICILAR (
    id INT IDENTITY(1,1) PRIMARY KEY,
    ad NVARCHAR(50),
    soyad NVARCHAR(50),
    yas INT
);
GO

SELECT*FROM KULLANICILAR

SELECT ad from KULLANICILAR --tüm sorgularý getirir.
SELECT ad, soyad from KULLANICILAR 
 insert into KULLANICILAR (ad,soyad,yas) values ('kemal', 'tas', 36)

 update KULLANICILAR --yas günceller wheredeki kiþinin
 set yas = 25
 where ad = 'kemal'

 delete from KULLANICILAR 
 where id=1 


 select distinct ad --eþsiz deðerleri getirir.
 from KULLANICILAR 

 select top 2 ad --seçtiðimiz adet kadar veri getirir.
 from KULLANICILAR










