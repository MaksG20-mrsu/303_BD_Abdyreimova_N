# -*- coding: utf-8 -*-
import os
import csv

def generate_sql():
    sql_file = 'Task02/db_init.sql'
    dataset_dir = 'dataset'
    
    with open(sql_file, 'w', encoding='utf-8') as f:
        f.write("-- Очистка старых таблиц перед инициализацией\n")
        f.write("DROP TABLE IF EXISTS movies;\n")
        f.write("DROP TABLE IF EXISTS ratings;\n")
        f.write("DROP TABLE IF EXISTS tags;\n")
        f.write("DROP TABLE IF EXISTS users;\n\n")
        
        f.write("-- Создание таблицы фильмов\n")
        f.write("CREATE TABLE movies (\n  id INTEGER PRIMARY KEY,\n  title TEXT,\n  year INTEGER,\n  genres TEXT\n);\n\n")
        
        f.write("-- Создание таблицы оценок\n")
        f.write("CREATE TABLE ratings (\n  id INTEGER PRIMARY KEY AUTOINCREMENT,\n  user_id INTEGER,\n  movie_id INTEGER,\n  rating REAL,\n  timestamp INTEGER\n);\n\n")
        
        f.write("-- Создание таблицы тегов\n")
        f.write("CREATE TABLE tags (\n  id INTEGER PRIMARY KEY AUTOINCREMENT,\n  user_id INTEGER,\n  movie_id INTEGER,\n  tag TEXT,\n  timestamp INTEGER\n);\n\n")
        
        f.write("-- Создание таблицы пользователей\n")
        f.write("CREATE TABLE users (\n  id INTEGER PRIMARY KEY,\n  name TEXT,\n  email TEXT,\n  gender TEXT,\n  register_date TEXT,\n  occupation TEXT\n);\n\n")
        
        f.write("-- Вставка исходных данных из датасета\n")
        
        # Чтение movies.csv
        with open(os.path.join(dataset_dir, 'movies.csv'), 'r', encoding='utf-8') as csv_f:
            reader = csv.reader(csv_f)
            next(reader)
            for row in reader:
                if len(row) >= 4:
                    title_esc = row[1].replace("'", "''")
                    year_val = row[2] if row[2] and row[2].isdigit() else 'NULL'
                    f.write(f"INSERT INTO movies (id, title, year, genres) VALUES ({row[0]}, '{title_esc}', {year_val}, '{row[3]}');\n")

        # Чтение ratings.csv
        with open(os.path.join(dataset_dir, 'ratings.csv'), 'r', encoding='utf-8') as csv_f:
            reader = csv.reader(csv_f)
            next(reader)
            for row in reader:
                if len(row) >= 4:
                    f.write(f"INSERT INTO ratings (user_id, movie_id, rating, timestamp) VALUES ({row[0]}, {row[1]}, {row[2]}, {row[3]});\n")

        # Чтение tags.csv
        with open(os.path.join(dataset_dir, 'tags.csv'), 'r', encoding='utf-8') as csv_f:
            reader = csv.reader(csv_f)
            next(reader)
            for row in reader:
                if len(row) >= 4:
                    tag_esc = row[2].replace("'", "''")
                    f.write(f"INSERT INTO tags (user_id, movie_id, tag, timestamp) VALUES ({row[0]}, {row[1]}, '{tag_esc}', {row[3]});\n")

        # Чтение users.txt
        with open(os.path.join(dataset_dir, 'users.txt'), 'r', encoding='utf-8') as txt_f:
            for line in txt_f:
                if line.startswith('id'): continue
                row = line.strip().split('\t')
                if len(row) >= 6:
                    name_esc = row[1].replace("'", "''")
                    f.write(f"INSERT INTO users (id, name, email, gender, register_date, occupation) VALUES ({row[0]}, '{name_esc}', '{row[2]}', '{row[3]}', '{row[4]}', '{row[5]}');\n")

    print("SQL-скрипт db_init.sql успешно сгенерирован на русском языке!")

if __name__ == '__main__':
    generate_sql()
