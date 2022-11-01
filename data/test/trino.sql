-- BEGIN bigquery
SELECT * FROM bigquery.samples.shakespeare LIMIT 1;
-- END bigquery

-- BEGIN hive
CREATE SCHEMA hive.tpch;
CREATE TABLE hive.tpch.nation AS SELECT * FROM tpch.tiny.nation;
SELECT * FROM hive.tpch.nation LIMIT 1;
-- END hive

-- BEGIN iceberg
CREATE SCHEMA iceberg.tpch;
CREATE TABLE iceberg.tpch.nation AS SELECT * FROM tpch.tiny.nation;
SELECT * FROM iceberg.tpch.nation LIMIT 1;
-- END iceberg

-- BEGIN mariadb
CREATE TABLE mariadb.tpch.nation AS SELECT * FROM tpch.tiny.nation;
SELECT * FROM mariadb.tpch.nation LIMIT 1;
-- END mariadb

-- BEGIN mongo
CREATE SCHEMA mongo.tpch;
CREATE TABLE mongo.tpch.nation AS SELECT * FROM tpch.tiny.nation;
SELECT * FROM mongo.tpch.nation LIMIT 1;
-- END mongo

-- BEGIN mysql
CREATE TABLE mysql.tpch.nation AS SELECT * FROM tpch.tiny.nation;
SELECT * FROM mysql.tpch.nation LIMIT 1;
-- END mysql

-- BEGIN postgres
CREATE SCHEMA postgres.tpch;
CREATE TABLE postgres.tpch.nation AS SELECT * FROM tpch.tiny.nation;
SELECT * FROM postgres.tpch.nation LIMIT 1;
-- END postgres

-- BEGIN scylla
CREATE TABLE scylla.tpch.nation AS SELECT * FROM tpch.tiny.nation;
SELECT * FROM scylla.tpch.nation LIMIT 1;
-- END scylla
