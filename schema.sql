DROP TABLE IF EXISTS mes;

CREATE TABLE mes (
    id serial  PRIMARY KEY,
    created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    temperature_max INTEGER NOT NULL,
    temperature_min INTEGER NOT NULL,
    humidity  INTEGER NOT NULL,
    stdate date NOT NULL
);
