USE DBGroupB; 

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
    gene_expr INT NOT NULL,
    PRIMARY KEY(gene_id, cell_id)
);

LOAD DATA LOCAL INFILE '/home/izzy_r/Group_project/Project_repo/Group_project/Website/SQL/sql_gene_matrix'
INTO TABLE expression
FIELDS TERMINATED BY '\t'
LINES TERMINATED BY '\n';

DROP TABLE IF EXISTS clusters;
CREATE TABLE clusters (
	cell_id VARCHAR(25) NOT NULL REFERENCES cell_info(cell_id),
    clust_5 INT NOT NULL,
    clust_6 INT NOT NULL,
    clust_7 INT NOT NULL,
    clust_8 INT NOT NULL,
    clust_9 INT NOT NULL,
    clust_10 INT NOT NULL,
    clust_11 INT NOT NULL,
    clust_12 INT NOT NULL,
    clust_13 INT NOT NULL,
    clust_14 INT NOT NULL,
    clust_15 INT NOT NULL,
    clust_16 INT NOT NULL,
    clust_17 INT NOT NULL,
    clust_18 INT NOT NULL,
    clust_19 INT NOT NULL,
    clust_20 INT NOT NULL,
    clust_21 INT NOT NULL,
    clust_22 INT NOT NULL,
    clust_23 INT NOT NULL,
    clust_24 INT NOT NULL,
    clust_25 INT NOT NULL,
    PRIMARY KEY(cell_id)
);

LOAD DATA LOCAL INFILE '/home/izzy_r/Group_project/Project_repo/Group_project/Website/SQL/cluster_assignment.csv'
INTO TABLE clusters
FIELDS TERMINATED BY '\t'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

DROP VIEW IF EXISTS alldata;

CREATE VIEW alldata AS
SELECT gene_id, cell_id, gene_expr, cell_info.cell_type, cell_info.tissue, cell_info.donor_age, 
clusters.clust_5, clusters.clust_6, clusters.clust_7, clusters.clust_8, clusters.clust_9, clusters.clust_10, clusters.clust_11, clusters.clust_12, clusters.clust_13, clusters.clust_14, clusters.clust_15, clusters.clust_16, clusters.clust_17, clusters.clust_18, clusters.clust_19, clusters.clust_20, clusters.clust_21, clusters.clust_22, clusters.clust_23, clusters.clust_24, clusters.clust_25
FROM expression NATURAL JOIN cell_info NATURAL JOIN clusters;

SELECT cell_id, gene_expr, clust_7, cell_type, tissue, donor_age FROM alldata WHERE gene_id='PLP1' ORDER BY gene_expr DESC;
