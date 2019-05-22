CREATE DATABASE bbs;
\c bbs;
CREATE TABLE IF NOT EXISTS users(
    -- id INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    name VARCHAR(50) NOT NULL
);

INSERT INTO users ("name")
    VALUES
        ('Akari Akaza'),
        ('Kyoko Toshino'),
        ('Yui Funami'),
        ('Chinatsu Yoshikawa')
;
