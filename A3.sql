/* Question 1*/
INSERT INTO Books
VALUES ('9781495968099', '2014-02-16', 134, 'Pan', 8);

SELECT AuthorID
FROM Author 
WHERE AuthorFirstName="Knut" AND AuthorLastName="Hamsun";

Select *
FROM Books
WHERE AuthorID=8;

/* Question 2*/
UPDATE Loans
SET LateReturnFIne = 0
WHERE LateReturnFine < 5;

Select *
FROM Loans
WHERE LateReturnFine < 5;

/* Question 3 */
DELETE FROM Books
WHERE ISBN IN (SELECT B.ISBN
						FROM Books B LEFT OUTER JOIN LOANS L ON B.ISBN=L.ISBN
						WHERE L.LoanDate IS NULL);

Select *
FROM Books B LEFT OUTER JOIN LOANS L ON B.ISBN=L.ISBN
WHERE L.LoanDate IS NULL;

/* Question 4*/
CREATE VIEW AuthorPublishedCat (FName, LName, BookCategory, NoBooks) AS
	SELECT A.AuthorFirstName, A.AuthorLastName, C.CategoryName, Count(*)
	FROM Author A, Categories C, BookCategories BC, Books B
	WHERE C.CategoryID=BC.CategoryID AND BC.ISBN=B.ISBN AND B.AuthorID=A.AuthorID
	GROUP BY C.CategoryID;
	
Select *
FROM AuthorPublishedCat

/* Question 5 */
CREATE VIEW NovelLoans (ISBN, Title, NoLoans) As
SELECT Q1.ISBN, Q1.Title, Q2.NoLoans
	FROM (SELECT B.ISBN, B.Title
			FROM Books B, BookCategories BC, Categories C
			WHERE B.ISBN=BC.ISBN AND BC.CategoryID=C.CategoryID AND C.CategoryName="Novel") AS Q1
LEFT OUTER JOIN
	(SELECT B.ISBN, COUNT(*) AS NoLoans
	FROM Books B, Loans L
	WHERE B.ISBN=L.ISBN
	GROUP BY B.ISBN) AS Q2 
	ON Q1.ISBN=Q2.ISBN;

SELECT * FROM NovelLoans

(SELECT B.ISBN, B.Title
FROM Books B, BookCategories BC, Categories C
WHERE B.ISBN=BC.ISBN AND BC.CategoryID=C.CategoryID AND C.CategoryName="Novel") AS Q1

(SELECT B.ISBN, COUNT(*) AS NoLoans
FROM Books B, Loans L
WHERE B.ISBN=L.ISBN
GROUP BY B.ISBN) AS Q2



/* Question 6*/
CREATE VIEW Fines (MemberName, NoBooksLoaned, TotalLateFine) AS
	SELECT Q1.MemberName, Q2.NoLoan, Q2.Tot
	FROM  (SELECT MemberName FROM Members) AS Q1 
			LEFT OUTER JOIN 
		(SELECT M.MemberName, Count (*) AS NoLoan, SUM(L.LateReturnFine) AS Tot
		FROM Members M, Loans L 
		WHERE M.MemberID=L.MemberID
		GROUP BY M.MemberName) AS Q2 
			ON Q1.MemberName=Q2.MemberName;


/* Question 7* is on the sheet */
SELECT * FROM CategoryCount
 /* a) */
SELECT DISTINCT MemberName 
FROM CategoryCount
WHERE LoanCount = 4;
/* b) */
SELECT * 
FROM CategoryCount
WHERE CategoryName = "Fantasy" AND LoanCount > 2;
/* c) */
UPDATE CategoryCount
SET LoanCount =0
WHERE CategoryName = "Action";

/* Question 8 */
SELECT M.MemberName
FROM Members M, Loans L
WHERE M.MemberID=L.MemberID AND L.ISBN IN (SELECT B.ISBN
																			FROM Books B, Author A
																			WHERE B.AuthorID=A.AuthorID AND A.AuthorID=14)
GROUP BY M.MemberName
HAVING COUNT(*) = 3;

SELECT M.MemberName
FROM Members M, Loans L, (SELECT B.ISBN, COUNT(*) As Tot
											FROM Books B, Author A
											WHERE B.AuthorID=A.AuthorID AND A.AuthorID=14) AS Q1
WHERE M.MemberID=L.MemberID AND L.ISBN IN (SELECT B.ISBN
																			FROM Books B, Author A
																			WHERE B.AuthorID=A.AuthorID AND A.AuthorID=14)
GROUP BY M.MemberName
HAVING COUNT(*) = Q1.Tot;

SELECT B.ISBN, B.Title
FROM Books B, Author A
WHERE B.AuthorID=A.AuthorID AND A.AuthorID=14

/* Question 9 */
SELECT M.MemberName, L.LoanDate, L.ReturnDate
FROM Members M, Loans L
WHERE  M.MemberID=L.MemberID 
				AND L.ISBN IN (SELECT ISBN
										FROM (SELECT B.ISBN, MAX(B.Pages)
													FROM Books B, BookCategories BC, Categories C
													WHERE B.ISBN=BC.ISBN AND BC.CategoryID=C.CategoryID
															AND CategoryName="Fantasy" ));
			
SELECT ISBN
FROM (SELECT B.ISBN, MAX(B.Pages)
		FROM Books B, BookCategories BC, Categories C
		WHERE B.ISBN=BC.ISBN AND BC.CategoryID=C.CategoryID AND CategoryName="Fantasy" )

SELECT B.ISBN, M.MemberName, B.Pages
		FROM Books B, BookCategories BC, Categories C, Members M, Loans L
		WHERE B.ISBN=BC.ISBN AND BC.CategoryID=C.CategoryID AND CategoryName="Fantasy"  AND L.ISBN=B.ISBN
		AND L.memberid=M.MemberID
		
/* Question 10 */


SELECT A.AuthorFirstName, A.AuthorLastName, B.Title
FROM Author A, Books B
WHERE A.AuthorID=B.AuthorID 
			AND B.ISBN IN (SELECT ISBN
									FROM  (SELECT B.ISBN, COUNT(*) AS CatCount
												FROM Books B, BookCategories BC
												WHERE B.ISBN=BC.ISBN
												GROUP BY B.ISBN)
									WHERE CatCount = 1);

SELECT ISBN
FROM 
	(SELECT B.ISBN, COUNT(*) AS CatCount
	FROM Books B, BookCategories BC
	WHERE B.ISBN=BC.ISBN
	GROUP BY B.ISBN)
WHERE CatCount = 1



