CREATE TABLE IF NOT EXISTS Genre (
    id INTEGER PRIMARY KEY,
    name VARCHAR (60) NOT NULL
);

CREATE TABLE IF NOT EXISTS Artist (
    id INTEGER PRIMARY KEY,
    name VARCHAR (160) NOT NULL
);
    
CREATE TABLE IF NOT EXISTS Album (
    id INTEGER PRIMARY KEY,
    name VARCHAR (60) NOT NULL,
    yearofrelease INTEGER NOT NULL,
    CHECK (1900 < yearofrelease),
    CHECK (yearofrelease < 2100)
);

CREATE TABLE IF NOT EXISTS Track (
    id INTEGER PRIMARY KEY,
    name VARCHAR (60) NOT NULL,
    album_id INTEGER NOT NULL REFERENCES Album(id),
    duration INTEGER NOT NULL,
    CHECK (duration < 3600)
);

CREATE TABLE IF NOT EXISTS Collection (
    id INTEGER PRIMARY KEY,
    name VARCHAR (60) NOT NULL,
    yearofrelease INTEGER NOT NULL,
    CHECK (1900 < yearofrelease),
    CHECK (yearofrelease < 2100)
);

CREATE TABLE IF NOT EXISTS Collection_Track (
    collection_id INTEGER NOT NULL REFERENCES Collection(id),
    track_id INTEGER NOT NULL REFERENCES Track(id),
    CONSTRAINT ct PRIMARY KEY (track_id, collection_id)
);
    
CREATE TABLE IF NOT EXISTS Genre_Artist (
    genre_id INTEGER NOT NULL REFERENCES Genre(id),
    artist_id INTEGER NOT NULL REFERENCES Artist(id),
    CONSTRAINT ga PRIMARY KEY (genre_id, artist_id)
);

CREATE TABLE IF NOT EXISTS Artist_Album (
    album_id INTEGER NOT NULL REFERENCES Album(id),
    artist_id INTEGER NOT NULL REFERENCES Artist(id),
    CONSTRAINT aa PRIMARY KEY (album_id, artist_id)
);

INSERT INTO Genre VALUES
(1, 'New metall'),
(2, 'Alt metall'),
(3, 'Rock'),
(4, 'Drum&bass')

INSERT INTO Artist VALUES 
(1, 'Limp Bizkit'),
(2, 'Sistem of a down'),
(3, 'Nirvana'),
(4, 'Pendulum'),
(5, 'Нейромонах Феофан')

INSERT INTO Genre_Artist (genre_id, Artist_id) VALUES 
(1,1),
(2,2),
(3,3),
(4,4),
(4,5)

INSERT INTO Album VALUES 
(1, 'Significant Other', 1999),
(2, 'Toxicity', 2001),
(3, 'Nevermind', 1991),
(4, 'Immersion', 2010),
(5, 'В душе драм, в сердце светлая Русь', 2019)

INSERT INTO Artist_Album (Artist_id, Album_id) VALUES 
(1,1),
(2,2),
(3,3),
(4,4),
(5,5)

INSERT INTO Track VALUES 
(1, 'My generation', 1, 231),
(2, 'Chop Suey!', 2, 210),
(3, 'Smells Like Teen Spirit', 3, 301),
(4, 'Witchcraft', 4, 252),
(5, 'Под драм легко', 5, 164),
(6, 'Светлая Русь', 5, 225)

INSERT INTO Collection VALUES
(1,'Incesticide', 1992),
(2,'Singles', 1995),
(3,'Nirvana (Greatest Hits)', 2002),
(4,'Древнерусский рейв', 2020)

INSERT INTO Collection_Track VALUES
(1,1),
(2,2),
(3,3),
(4,4)


SELECT name, duration FROM Track
ORDER BY duration 

SELECT name FROM Track
WHERE duration >= 210;


SELECT name FROM Collection
WHERE yearofrelease >= 2018 AND yearofrelease <= 2020;

SELECT name FROM Artist
WHERE name NOT LIKE '% %';

SELECT name FROM Track
WHERE name ILIKE '% my %'
OR name ILIKE '%my %'
OR name ILIKE '% my%'
OR name ILIKE 'my'
OR name ILIKE '% мой %'
OR name ILIKE '%мой %'
OR name ILIKE '% мой%'
OR name ILIKE 'мой'







SELECT  count(*) as "Количество", name as "Жанр"
from genre_artist ga
LEFT JOIN  genre g 
on g.id = ga.genre_id 
group by 2 order by 1;




SELECT  count(*) as "Количество", a.name as "Альбом" FROM album a
LEFT JOIN Track t ON a.id = t.album_id
WHERE yearofrelease >= 2019 AND yearofrelease <= 2020
group by 2 order by 1;


SELECT  AVG(duration) as "Средняя длительность", a.name as "Альбом" FROM album a
INNER JOIN Track t ON a.id = t.album_id
group by 2 order by 1;



SELECT 
  name as "Иcполнитель"
FROM artist
WHERE id NOT IN 
  (SELECT 
    artist_id 
  FROM artist_album
  WHERE album_id IN (
    SELECT 
      id
    FROM album
    WHERE yearofrelease = 2020
    GROUP BY id)
  GROUP BY artist_id);


SELECT 
  c.name as "Название сборника"
FROM Collection AS c
LEFT JOIN Collection_Track AS ct ON c.id = ct.Collection_id
LEFT JOIN track AS t ON ct.track_id = t.id
LEFT JOIN album AS al ON t.album_id = al.id
LEFT JOIN artist_album AS aa ON aa.album_id = al.id
LEFT JOIN artist AS a ON a.id = aa.artist_id 
WHERE a.name = 'Nirvana'


