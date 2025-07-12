#!/bin/bash
docker exec -u postgres pg_dte_test psql -c "CREATE DATABASE testdb;"
docker exec -u postgres pg_dte_test psql -d testdb -c "CREATE TABLE users (id SERIAL PRIMARY KEY, name TEXT);"
docker exec -u postgres pg_dte_test psql -d testdb -c "INSERT INTO users (name) VALUES ('Alice'), ('Bob');"
docker exec -u postgres pg_dte_test psql -d testdb -c "SELECT * FROM users;"