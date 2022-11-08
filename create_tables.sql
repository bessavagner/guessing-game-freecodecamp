CREATE TABLE users(
    user_id SERIAL PRIMARY KEY,
    name VARCHAR(30) NOT NULL
);

CREATE TABLE games(
    game_id SERIAL PRIMARY KEY,
    guesses INTEGER NOT NULL,
    user_id INTEGER NOT NULL
);

ALTER TABLE games ADD FOREIGN KEY(user_id) REFERENCES users(user_id);
