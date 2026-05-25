-- Schema
CREATE TABLE IF NOT EXISTS tasks (
  id INTEGER PRIMARY KEY,
  title TEXT NOT NULL,
  description TEXT,
  priority TEXT,
  status TEXT,
  category TEXT,
  assigned_to TEXT,
  deadline TEXT,
  follow_up TEXT,
  reminder TEXT,
  dependencies TEXT,
  notes TEXT,
  project TEXT,
  created_at TEXT DEFAULT (datetime('now')),
  updated_at TEXT DEFAULT (datetime('now')),
  source TEXT
);

CREATE TABLE IF NOT EXISTS contacts (
  id INTEGER PRIMARY KEY,
  name TEXT NOT NULL,
  company TEXT,
  role TEXT,
  email TEXT,
  phone TEXT,
  notes TEXT,
  created_at TEXT DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS events (
  id INTEGER PRIMARY KEY,
  title TEXT NOT NULL,
  start TEXT,
  end TEXT,
  description TEXT,
  location TEXT,
  created_at TEXT DEFAULT (datetime('now'))
);
