SELECT * FROM bigquery.samples.shakespeare LIMIT 1;

CREATE SCHEMA hive.tpch;
CREATE TABLE hive.tpch.nation AS SELECT * FROM tpch.tiny.nation;
SELECT * FROM hive.tpch.nation LIMIT 1;

CREATE SCHEMA iceberg.tpch;
CREATE TABLE iceberg.tpch.nation AS SELECT * FROM tpch.tiny.nation;
SELECT * FROM iceberg.tpch.nation LIMIT 1;

CREATE TABLE mariadb.tpch.nation AS SELECT * FROM tpch.tiny.nation;
SELECT * FROM mariadb.tpch.nation LIMIT 1;

CREATE TABLE mysql.tpch.nation AS SELECT * FROM tpch.tiny.nation;
SELECT * FROM mysql.tpch.nation LIMIT 1;

CREATE SCHEMA postgres.tpch;
CREATE TABLE postgres.tpch.nation AS SELECT * FROM tpch.tiny.nation;
SELECT * FROM postgres.tpch.nation LIMIT 1;

CREATE TABLE scylla.tpch.nation AS SELECT * FROM tpch.tiny.nation;
SELECT * FROM scylla.tpch.nation LIMIT 1;
