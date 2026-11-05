-- Добавление новых профессий в справочник
INSERT OR IGNORE INTO occupations (name) VALUES ('Student'), ('Engineer');

-- Добавление 5 новых пользователей (вы и 4 одногруппника)
-- ID генерируются автоматически на основе существующих (MAX(id) + 1)
INSERT INTO users (id, name, email, gender, occupation_id) 
SELECT (SELECT COALESCE(MAX(id), 0) + 1 FROM users), 'Абдырейимова Нурана', 'nuranaabdyreyimowa18@gmail.com', 'F', 1;

INSERT INTO users (id, name, email, gender, occupation_id) 
SELECT (SELECT COALESCE(MAX(id), 0) + 1 FROM users), 'Пьянов Леонид', 'pyanov@mrsu.ru', 'M', 1;

INSERT INTO users (id, name, email, gender, occupation_id) 
SELECT (SELECT COALESCE(MAX(id), 0) + 1 FROM users), 'Житина Валентина', 'zhitina@mrsu.ru', 'F', 1;

INSERT INTO users (id, name, email, gender, occupation_id) 
SELECT (SELECT COALESCE(MAX(id), 0) + 1 FROM users), 'Марусин Игорь', 'marusin@mrsu.ru', 'M', 1;

INSERT INTO users (id, name, email, gender, occupation_id) 
SELECT (SELECT COALESCE(MAX(id), 0) + 1 FROM users), 'Петров Петр', 'petrov@mrsu.ru', 'M', 2;

-- Добавление 3 новых фильмов разных жанров
INSERT INTO movies (id, title, year, genres)
SELECT (SELECT COALESCE(MAX(id), 0) + 1 FROM movies), 'Interstellar', 2014, 'Sci-Fi|Drama';

INSERT INTO movies (id, title, year, genres)
SELECT (SELECT COALESCE(MAX(id), 0) + 1 FROM movies), 'The Hangover', 2009, 'Comedy';

INSERT INTO movies (id, title, year, genres)
SELECT (SELECT COALESCE(MAX(id), 0) + 1 FROM movies), 'Inception', 2010, 'Action|Sci-Fi|Thriller';

-- Добавление 3 отзывов от себя лично на новые фильмы
-- user_id берется динамически для Абдырейимы Нураны
INSERT INTO ratings (user_id, movie_id, rating)
SELECT (SELECT id FROM users WHERE email = 'nuranaabdyreyimowa18@gmail.com'), (SELECT id FROM movies WHERE title = 'Interstellar'), 5.0;

INSERT INTO ratings (user_id, movie_id, rating)
SELECT (SELECT id FROM users WHERE email = 'nuranaabdyreyimowa18@gmail.com'), (SELECT id FROM movies WHERE title = 'The Hangover'), 4.5;

INSERT INTO ratings (user_id, movie_id, rating)
SELECT (SELECT id FROM users WHERE email = 'nuranaabdyreyimowa18@gmail.com'), (SELECT id FROM movies WHERE title = 'Inception'), 4.8;
