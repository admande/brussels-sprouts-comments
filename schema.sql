DROP TABLE IF EXISTS recipes;

CREATE TABLE recipes (
  id SERIAL PRIMARY KEY,
  title VARCHAR(100),
);


DROP TABLE IF EXISTS comments;

CREATE TABLE recipes (
  id SERIAL PRIMARY KEY,
  comment VARCHAR(255)
  recipe_id INTEGER,
);
