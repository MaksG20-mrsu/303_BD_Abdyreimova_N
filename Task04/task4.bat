#!/bin/bash
chcp 65001

sqlite3 movies_rating.db < Task04/db_init.sql

echo "1. Найти все пары пользователей, оценивших один и тот же фильм. Устранить дубликаты..."
echo "--------------------------------------------------"
sqlite3 movies_rating.db -box "SELECT DISTINCT u1.name AS [Пользователь 1], u2.name AS [Пользователь 2], m.title AS [Фильм] FROM ratings r1 JOIN ratings r2 ON r1.movie_id = r2.movie_id AND r1.user_id < r2.user_id JOIN users u1 ON r1.user_id = u1.id JOIN users u2 ON r2.user_id = u2.id JOIN movies m ON r1.movie_id = m.id LIMIT 100;"
echo " "

echo "2. Найти 10 самых свежих оценок от разных пользователей..."
echo "--------------------------------------------------"
sqlite3 movies_rating.db -box "SELECT m.title, u.name, r.rating, date(r.timestamp, 'unixepoch') AS [Дата] FROM (SELECT *, ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY timestamp DESC) as rn FROM ratings) r JOIN users u ON r.user_id = u.id JOIN movies m ON r.movie_id = m.id WHERE r.rn = 1 ORDER BY r.timestamp DESC LIMIT 10;"
echo " "

echo "3. Вывести в одном списке все фильмы с максимальным средним рейтингом и с минимальным..."
echo "--------------------------------------------------"
sqlite3 movies_rating.db -box "WITH avg_ratings AS (SELECT movie_id, AVG(rating) as avg_r FROM ratings GROUP BY movie_id), max_min AS (SELECT MAX(avg_r) as max_r, MIN(avg_r) as min_r FROM avg_ratings) SELECT m.title, m.year, ar.avg_r, CASE WHEN ar.avg_r = mm.max_r THEN 'Да' ELSE 'Нет' END AS [Рекомендуем] FROM avg_ratings ar JOIN movies m ON ar.movie_id = m.id JOIN max_min mm ON ar.avg_r = mm.max_r OR ar.avg_r = mm.min_r ORDER BY m.year ASC, m.title ASC;"
echo " "

echo "4. Вычислить количество оценок и среднюю оценку, которую дали фильмам пользователи-женщины в период с 2010 по 2012 год."
echo "--------------------------------------------------"
sqlite3 movies_rating.db -box "SELECT COUNT(r.id) AS [Количество], AVG(r.rating) AS [Средняя оценка] FROM ratings r JOIN users u ON r.user_id = u.id WHERE u.gender = 'F' AND strftime('%Y', r.timestamp, 'unixepoch') BETWEEN '2010' AND '2012';"
echo " "

echo "5. Составить список фильмов с указанием их средней оценки и места в рейтинге по средней оценке. Оставить первые 20."
echo "--------------------------------------------------"
sqlite3 movies_rating.db -box "WITH ranked_movies AS (SELECT movie_id, AVG(rating) as avg_r, DENSE_RANK() OVER (ORDER BY AVG(rating) DESC) as rank_place FROM ratings GROUP BY movie_id) SELECT m.title, m.year, rm.avg_r, rm.rank_place FROM ranked_movies rm JOIN movies m ON rm.movie_id = m.id ORDER BY m.year ASC, m.title ASC LIMIT 20;"
echo " "

echo "6. Вывести список из 10 последних зарегистрированных пользователей в формате 'Фамилия Имя|Дата регистрации' (сначала фамилия, потом имя)."
echo "--------------------------------------------------"
sqlite3 movies_rating.db -box "SELECT SUBSTR(name, INSTR(name, ' ') + 1) || ' ' || SUBSTR(name, 1, INSTR(name, ' ') - 1) || '|' || register_date AS [Пользователь|Дата] FROM users ORDER BY register_date DESC LIMIT 10;"
echo " "

echo "7. С помощью рекурсивного СТЕ составить таблицу умножения для чисел от 1 до 10. Должен получиться один столбец."
echo "--------------------------------------------------"
sqlite3 movies_rating.db -box "WITH RECURSIVE numbers(n) AS (SELECT 1 UNION ALL SELECT n + 1 FROM numbers WHERE n < 10), multiplication AS (SELECT n1.n AS x, n2.n AS y FROM numbers n1 CROSS JOIN numbers n2) SELECT x || 'x' || y || '=' || (x * y) AS [Таблица умножения] FROM multiplication;"
echo " "

echo "8. С помощью рекурсивного СТЕ выделить все жанры фильмов, имеющиеся в таблице movies (каждый жанр в отдельной строке)."
echo "--------------------------------------------------"
sqlite3 movies_rating.db -box "WITH RECURSIVE split(genre, remainder) AS (SELECT NULL, genres || '|' FROM movies UNION ALL SELECT SUBSTR(remainder, 1, INSTR(remainder, '|') - 1), SUBSTR(remainder, INSTR(remainder, '|') + 1) FROM split WHERE remainder <> '') SELECT DISTINCT genre FROM split WHERE genre IS NOT NULL AND genre <> '';"
echo " "
