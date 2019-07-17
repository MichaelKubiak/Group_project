CREATE DATABASE IF NOT EXISTS webserver;
USE webserver; 

DROP TABLE IF EXISTS cell_info;
CREATE TABLE cell_info (
	cell_id VARCHAR(25) NOT NULL,
    donor_age VARCHAR(50) NOT NULL,
    cell_type VARCHAR(100) NOT NULL,
    tissue VARCHAR(50) NOT NULL,
    PRIMARY KEY(cell_id)
);

LOAD DATA LOCAL INFILE '/home/izzy_r/Group_project/Project_repo/Group_project/Website/SQL/sql_SRA_run_table.csv'
INTO TABLE cell_info
FIELDS TERMINATED BY '\t'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

DROP TABLE IF EXISTS expression;
CREATE TABLE expression (
	gene_id VARCHAR(25) NOT NULL,
    cell_id VARCHAR(25) NOT NULL REFERENCES cell_info(cell_id),
    expression INT NOT NULL,
    PRIMARY KEY(gene_id, cell_id)
);


LOAD DATA LOCAL INFILE '/home/izzy_r/Group_project/Project_repo/Group_project/Website/SQL/sql_gene_matrix'
INTO TABLE expression
FIELDS TERMINATED BY '\t'
LINES TERMINATED BY '\n';

