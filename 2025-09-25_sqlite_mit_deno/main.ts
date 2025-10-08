import { DatabaseSync } from "node:sqlite";

const db = new DatabaseSync("2ahwii.db");
const stmt = db.prepare("SELECT * FROM students");
const rows = stmt.all();
console.log(rows);

const insertStmt = db.prepare("INSERT INTO students (id, name, birthdate) VALUES (?, ?, ?)");
insertStmt.run(249, 'Nora', '2010-05-15');