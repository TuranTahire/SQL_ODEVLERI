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

SELECT ad from KULLANICILAR --t�m sorgular� getirir.
SELECT ad, soyad from KULLANICILAR 
 insert into KULLANICILAR (ad,soyad,yas) values ('kemal', 'tas', 36)

 update KULLANICILAR --yas g�nceller wheredeki ki�inin
 set yas = 25
 where ad = 'kemal'

 delete from KULLANICILAR 
 where id=1 


 select distinct ad --e�siz de�erleri getirir.
 from KULLANICILAR 

 select top 2 ad --se�ti�imiz adet kadar veri getirir.
 from KULLANICILAR










