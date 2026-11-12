-- Очистка старых таблиц перед инициализацией
PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS ratings;
DROP TABLE IF EXISTS tags;
DROP TABLE IF EXISTS movies;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS occupations;

-- 1. Справочник профессий для 3-й нормальной формы
CREATE TABLE occupations (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT UNIQUE NOT NULL
);

-- 2. Создание таблицы пользователей с ограничениями логической целостности
CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  name TEXT NOT NULL,
  email TEXT UNIQUE NOT NULL, -- Не может быть двух пользователей с одинаковым e-mail
  gender TEXT CHECK(gender IN ('M', 'F')), -- Пол только мужской (M) или женский (F)
  register_date TEXT DEFAULT (datetime('now', 'localtime')), -- Дата по системному времени
  occupation_id INTEGER,
  FOREIGN KEY (occupation_id) REFERENCES occupations(id)
);

-- 3. Создание таблицы фильмов
CREATE TABLE movies (
  id INTEGER PRIMARY KEY,
  title TEXT NOT NULL,
  year INTEGER,
  genres TEXT
);

-- 4. Создание таблицы оценок с ограничениями каскадного удаления
CREATE TABLE ratings (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER,
  movie_id INTEGER,
  rating REAL CHECK(rating BETWEEN 0.0 AND 5.0), -- Рейтинг от 0 до 5 включительно
  timestamp INTEGER DEFAULT (strftime('%s', 'now')),
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE, -- При удалении пользователя удаляются все его отзывы
  FOREIGN KEY (movie_id) REFERENCES movies(id) ON DELETE RESTRICT -- Нельзя удалить фильм, если по нему есть отзывы
);

-- 5. Создание таблицы тегов
CREATE TABLE tags (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER,
  movie_id INTEGER,
  tag TEXT NOT NULL,
  timestamp INTEGER DEFAULT (strftime('%s', 'now')),
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (movie_id) REFERENCES movies(id) ON DELETE RESTRICT
);

-- Создание индексов для ускорения поиска
CREATE INDEX idx_users_name ON users(name);
CREATE INDEX idx_movies_title ON movies(title);
CREATE INDEX idx_movies_year ON movies(year);
