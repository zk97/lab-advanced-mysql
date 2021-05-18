USE publications;

-- CHALLENGE 1
CREATE TEMPORARY TABLE royalties 
SELECT titles.title_id AS TitleID, titleauthor.au_id AS AuthorID, 
titles.price*sales.qty*(titles.royalty/100)*(titleauthor.royaltyper/100) AS Royalty
FROM titleauthor 
JOIN titles ON titles.title_id=titleauthor.title_id
JOIN sales ON titles.title_id=sales.title_id;

CREATE TEMPORARY TABLE royal_au_tit
SELECT TitleID, AuthorID, 
SUM(Royalty) AS Royalties
FROM royalties
GROUP BY royalties.TitleID, royalties.AuthorID;

SELECT AuthorID, SUM(titles.advance*(titleauthor.royaltyper/100)+Royalties) AS Profit
FROM royal_au_tit
JOIN titles ON royal_au_tit.TitleID=titles.title_id
JOIN titleauthor ON titles.title_id=titleauthor.title_id AND royal_au_tit.AuthorID = titleauthor.au_id
GROUP BY royal_au_tit.AuthorID
ORDER BY Profit DESC
LIMIT 3;

-- CHALLENGE 2
SELECT AuthorID, SUM(titles.advance*(titleauthor.royaltyper/100)+Royalties) AS Profit
FROM (SELECT TitleID, AuthorID, 
        SUM(Royalty) AS Royalties
        FROM (SELECT titles.title_id AS TitleID, titleauthor.au_id AS AuthorID, 
                titles.price*sales.qty*(titles.royalty/100)*(titleauthor.royaltyper/100) AS Royalty
                FROM titleauthor 
                JOIN titles ON titles.title_id=titleauthor.title_id
                JOIN sales ON titles.title_id=sales.title_id) AS royalties
        GROUP BY royalties.TitleID, royalties.AuthorID) AS royal_au_tit
        JOIN titles ON royal_au_tit.TitleID=titles.title_id
JOIN titleauthor ON titles.title_id=titleauthor.title_id AND royal_au_tit.AuthorID = titleauthor.au_id
GROUP BY royal_au_tit.AuthorID
ORDER BY Profit DESC
LIMIT 3;

-- CHALLENGE 3
CREATE TABLE most_profiting_authors SELECT AuthorID AS 'au_id', SUM(titles.advance*(titleauthor.royaltyper/100)+Royalties) AS 'profits'
FROM (  SELECT TitleID, AuthorID, 
        SUM(Royalty) AS Royalties
        FROM (SELECT titles.title_id AS TitleID, titleauthor.au_id AS AuthorID, 
                titles.price*sales.qty*(titles.royalty/100)*(titleauthor.royaltyper/100) AS Royalty
                FROM titleauthor 
                JOIN titles ON titles.title_id=titleauthor.title_id
                JOIN sales ON titles.title_id=sales.title_id) AS royalties
        GROUP BY royalties.TitleID, royalties.AuthorID) AS royal_au_tit
        JOIN titles ON royal_au_tit.TitleID=titles.title_id
JOIN titleauthor ON titles.title_id=titleauthor.title_id AND royal_au_tit.AuthorID = titleauthor.au_id
GROUP BY royal_au_tit.AuthorID
ORDER BY profits DESC;