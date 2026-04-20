--  1.) studieren von sum und Avg
-- 
--     -sum
--         berechnet die summe von Numbers einer Spalte (bzw. dem  ausgewählten Bereich einer Spalte)
-- 
--     -avg
--         berechnet den durchschnitswert von Numbers einer Spalte (bzw. dem  ausgewählten Bereich einer Spalte)
-- 
-- 
--  2.) 5 sinnvolle statements in opentrivia
-- 
--     leider habe ich die opentrivia datenbank nicht und hab auf der Website nicht den download link gefunden

--5 sinnvolle statements

--1.)
SELECT SUM(opentdb_id)
FROM category;

--2.)
SELECT AVG(opentdb_id)
FROM category
WHERE opentdb_id % 2 = 0;

--3.)
SELECT name FROM category
WHERE name LIKE 'entertainment%';

--4.)
SELECT SUM(opentdb_id)
FROM category
WHERE name LIKE 'science%';

--5.)
SELECT AVG(opentdb_id)
FROM category
WHERE name LIKE 'entertainment%';