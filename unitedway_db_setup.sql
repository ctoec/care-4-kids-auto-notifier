
CREATE DATABASE IF NOT EXISTS unitedwayetl;

CREATE USER IF NOT EXISTS 'skylight'@'localhost' IDENTIFIED BY 'userpassword';
GRANT SELECT ON  unitedwayetl . * TO   'skylight'@'localhost';

USE unitedwayetl;

CREATE TABLE IF NOT EXISTS docuclass_indexed ( caseid varchar(20) not null, document_type varchar(20) not null, index_date date not null );
CREATE TABLE IF NOT EXISTS impact_indexed ( caseid varchar(20) not null, document_type varchar(20) not null, index_date date not null );
