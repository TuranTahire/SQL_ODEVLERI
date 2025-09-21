--CREATE DATABASE library_db;

USE library_db;
GO

IF OBJECT_ID('books', 'U') IS NULL
BEGIN
    CREATE TABLE books (
        book_id INT PRIMARY KEY IDENTITY(1,1),
        title NVARCHAR(255) NOT NULL,
        author NVARCHAR(255) NOT NULL,
        genre NVARCHAR(100),
        price DECIMAL(10, 2) CHECK (price >= 0),
        stock INT CHECK (stock >= 0),
        published_year INT CHECK (published_year BETWEEN 1900 AND 2025),
        added_at DATE DEFAULT GETDATE()
    );
    PRINT 'Tablo "books" ba�ar�yla olu�turuldu.';
END
GO

IF NOT EXISTS (SELECT 1 FROM books)
BEGIN
    INSERT INTO books (title, author, genre, price, stock, published_year, added_at)
    VALUES
        ('Kay�p Zaman�n �zinde', 'M. Proust', 'Roman', 129.90, 25, 1913, '2025-08-20'),
        ('Simyac�', 'P. Coelho', 'Roman', 89.50, 40, 1988, '2025-08-21'),
        ('Sapiens', 'Y. N. Harari', 'Tarih', 159.00, 18, 2011, '2025-08-25'),
        ('�nce Memed', 'Y. Kemal', 'Roman', 99.90, 12, 1955, '2025-08-22'),
        ('K�rl�k', 'J. Saramago', 'Roman', 119.00, 7, 1995, '2025-08-28'),
        ('Dune', 'F. Herbert', 'Bilim', 149.00, 30, 1965, '2025-09-01'),
        ('Hayvan �iftli�i', 'G. Orwell', 'Roman', 79.90, 55, 1945, '2025-08-23'),
        ('1984', 'G. Orwell', 'Roman', 99.00, 35, 1949, '2025-08-24'),
        ('Nutuk', 'M. K. Atat�rk', 'Tarih', 139.00, 20, 1927, '2025-08-27'),
        ('K���k Prens', 'A. de Saint-Exup�ry', '�ocuk', 69.90, 80, 1943, '2025-08-26'),
        ('Ba�lang��', 'D. Brown', 'Roman', 109.00, 22, 2017, '2025-09-02'),
        ('Atomik Al��kanl�klar', 'J. Clear', 'Ki�isel Geli�im', 129.00, 28, 2018, '2025-09-03'),
        ('Zaman�n K�sa Tarihi', 'S. Hawking', 'Bilim', 119.50, 16, 1988, '2025-08-29'),
        ('�eker Portakal�', 'J. M. de Vasconcelos', 'Roman', 84.90, 45, 1968, '2025-08-30'),
        ('Bir �dam Mahk�munun Son G�n�', 'V. Hugo', 'Roman', 74.90, 26, 1929, '2025-08-31');

    PRINT '15 kitap verisi ba�ar�yla eklendi.';
END
ELSE
BEGIN
    PRINT 'Tabloda zaten veri var, ekleme ad�m� atland�.';
END
GO

--G�REVLER
SELECT title,author,price FROM books ORDER BY price ASC;
SELECT*FROM books WHERE genre='Roman' ORDER BY title ASC;
SELECT*FROM books WHERE price BETWEEN 80 AND 120;
SELECT title,stock FROM books WHERE stock <20;
SELECT*FROM books WHERE LOWER(title) LIKE '%zaman%';
SELECT*FROM books WHERE genre IN ('Roman','Bilim');
SELECT*FROM books WHERE published_year >= 2000 ORDER BY published_year DESC;
SELECT*FROM books WHERE added_at >= DATEADD(day, -10, GETDATE());
SELECT TOP 5*FROM books ORDER BY price DESC;
SELECT*FROM books WHERE stock BETWEEN 30 AND 60 ORDER BY price ASC; 