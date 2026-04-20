-- ============================================================================
-- HAUSAUFGABE: N-zu-M-Beziehungen mit Zwischentabellen
-- Thema: Bibliotheksverwaltung mit Ausleihen
-- Lösung
-- ============================================================================

DROP TABLE IF EXISTS ausleihe;
DROP TABLE IF EXISTS buch;
DROP TABLE IF EXISTS leser;

-- ============================================================================
-- AUFGABE 1: LESER-TABELLE (5 Punkte, ca. 5 Min.)
-- ============================================================================
CREATE TABLE leser (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    email TEXT NOT NULL UNIQUE,
    mitglied_seit DATE NOT NULL
);

-- ============================================================================
-- AUFGABE 2: BUCH-TABELLE (5 Punkte, ca. 5 Min.)
-- ============================================================================
CREATE TABLE buch (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    titel TEXT NOT NULL,
    autor TEXT NOT NULL,
    isbn TEXT UNIQUE,
    erscheinungsjahr INTEGER
);

-- ============================================================================
-- AUFGABE 3: AUSLEIHE-ZWISCHENTABELLE (20 Punkte, ca. 20 Min.)
-- ============================================================================
CREATE TABLE ausleihe (
    leser_id INTEGER NOT NULL,
    buch_id INTEGER NOT NULL,
    ausleih_datum DATE NOT NULL,
    rueckgabe_datum DATE,
    anzahl_tage INTEGER NOT NULL,
    PRIMARY KEY (leser_id, buch_id, ausleih_datum),
    FOREIGN KEY (leser_id) REFERENCES leser(id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    FOREIGN KEY (buch_id) REFERENCES buch(id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    CHECK (anzahl_tage > 0)
);

-- ============================================================================
-- AUFGABE 4: INDEXE ERSTELLEN (5 Punkte, ca. 5 Min.)
-- ============================================================================
-- Index für schnelle Suche nach Leser-Namen
CREATE INDEX idx_leser_name ON leser(name);

-- Index für schnelle Suche nach Buch-Titeln
CREATE INDEX idx_buch_titel ON buch(titel);

-- Index für schnelle Abfrage: Welche Bücher sind aktuell ausgeliehen?
-- Begründung: Ermöglicht effiziente Suche nach NULL-Werten in rueckgabe_datum
CREATE INDEX idx_ausleihe_rueckgabe ON ausleihe(rueckgabe_datum);

-- ============================================================================
-- AUFGABE 5: BEISPIELDATEN EINFÜGEN (5 Punkte, ca. 5 Min.)
-- ============================================================================
-- Leser einfügen
INSERT INTO leser (id, name, email, mitglied_seit) VALUES
    (1, 'Max Mustermann', 'max@email.de', '2023-01-15'),
    (2, 'Maria Musterfrau', 'maria@email.de', '2023-03-20'),
    (3, 'Peter Schmidt', 'peter@email.de', '2024-01-10');

-- Bücher einfügen
INSERT INTO buch (id, titel, autor, isbn, erscheinungsjahr) VALUES
    (1, 'Der Herr der Ringe', 'J.R.R. Tolkien', '978-3608939791', 1954),
    (2, 'Harry Potter 1', 'J.K. Rowling', '978-3551551679', 1997),
    (3, 'Die Verwandlung', 'Franz Kafka', '978-3150099007', 1915),
    (4, '1984', 'George Orwell', '978-3548234106', 1949);

-- Ausleihen einfügen
INSERT INTO ausleihe (leser_id, buch_id, ausleih_datum, rueckgabe_datum, anzahl_tage) VALUES
    (1, 1, '2024-01-10', '2024-01-24', 14),
    (1, 2, '2024-02-01', NULL, 10),
    (2, 4, '2024-01-15', '2024-01-22', 7),
    (2, 1, '2024-02-05', NULL, 21),
    (3, 3, '2024-01-20', '2024-01-25', 5);

-- ============================================================================
-- AUFGABE 6: ABFRAGEN SCHREIBEN (10 Punkte, ca. 10 Min.)
-- ============================================================================

-- a) Zeige alle Ausleihen mit Lesernamen, Buchtitel und Ausleihzeitraum
--    Sortiert nach Ausleihdatum (neueste zuerst)
SELECT 
    l.name AS leser_name,
    b.titel AS buch_titel,
    a.ausleih_datum,
    a.rueckgabe_datum,
    a.anzahl_tage
FROM ausleihe a
JOIN leser l ON a.leser_id = l.id
JOIN buch b ON a.buch_id = b.id
ORDER BY a.ausleih_datum DESC;

-- b) Welche Bücher sind aktuell ausgeliehen?
--    (Titel, Lesername, seit wann ausgeliehen)
SELECT 
    b.titel AS buch_titel,
    l.name AS leser_name,
    a.ausleih_datum AS seit
FROM ausleihe a
JOIN leser l ON a.leser_id = l.id
JOIN buch b ON a.buch_id = b.id
WHERE a.rueckgabe_datum IS NULL;

-- c) Wie oft wurde jedes Buch insgesamt ausgeliehen?
--    (Titel + Anzahl der Ausleihen)
SELECT 
    b.titel AS buch_titel,
    COUNT(a.buch_id) AS anzahl_ausleihen
FROM buch b
LEFT JOIN ausleihe a ON b.id = a.buch_id
GROUP BY b.id, b.titel;

-- d) Welcher Leser hat die meisten Bücher insgesamt ausgeliehen?
SELECT 
    l.name AS leser_name,
    COUNT(a.leser_id) AS anzahl_ausleihen
FROM leser l
JOIN ausleihe a ON l.id = a.leser_id
GROUP BY l.id, l.name
ORDER BY anzahl_ausleihen DESC
LIMIT 1;

-- ============================================================================
-- BONUSAUFGABE (Optional, +5 Punkte)
-- ============================================================================
CREATE VIEW aktuelle_ausleihen AS
SELECT 
    l.name AS leser_name,
    b.titel AS buch_titel,
    a.ausleih_datum
FROM ausleihe a
JOIN leser l ON a.leser_id = l.id
JOIN buch b ON a.buch_id = b.id
WHERE a.rueckgabe_datum IS NULL;
