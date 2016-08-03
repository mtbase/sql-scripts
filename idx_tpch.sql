-- Database Index Creation for TPC-H Benchmark
-- (c) 2016 @braunl @marenato

-- PostgreSQL automatically creates a unique index when a unique constraint or primary key is defined for a table
-- https://www.postgresql.org/docs/9.5/static/indexes-unique.html
-- MySql InnoDB (which is the default engine) does the same:
-- http://dev.mysql.com/doc/refman/5.7/en/mysql-indexes.html

ALTER TABLE Region ADD PRIMARY KEY (R_regionkey);

ALTER TABLE Nation ADD PRIMARY KEY (N_nationkey);

ALTER TABLE Part ADD PRIMARY KEY (P_partkey);

ALTER TABLE Supplier ADD PRIMARY KEY (S_suppkey);

ALTER TABLE Partsupp ADD PRIMARY KEY (PS_partkey, PS_suppkey);
ALTER TABLE Partsupp ADD FOREIGN KEY(PS_partkey) REFERENCES Part(P_partkey);
ALTER TABLE Partsupp ADD FOREIGN KEY (PS_suppkey) REFERENCES Supplier(S_suppkey);

CREATE INDEX PS_part_index ON Partsupp (PS_partkey);
CREATE INDEX PS_supp_index ON Partsupp (PS_suppkey);
                        
ALTER TABLE Customer ADD PRIMARY KEY (C_custkey);
ALTER TABLE Customer ADD FOREIGN KEY (C_nationkey) REFERENCES Nation(N_nationkey);
CREATE INDEX C_nation_index ON Customer (C_nationkey);

ALTER TABLE Orders ADD PRIMARY KEY (O_orderkey);
ALTER TABLE Orders ADD FOREIGN KEY (O_custkey) REFERENCES Customer(C_custkey);
CREATE INDEX O_cust_index ON Orders(O_custkey);

ALTER TABLE Lineitem ADD PRIMARY KEY(L_orderkey, L_linenumber);
ALTER TABLE Lineitem ADD FOREIGN KEY (L_orderkey) REFERENCES Orders(O_orderkey);
ALTER TABLE Lineitem ADD FOREIGN KEY (L_partkey, L_suppkey) REFERENCES Partsupp(PS_partkey, PS_suppkey);
CREATE INDEX L_PARTSUPP_INDEX ON Lineitem (L_partkey, L_suppkey);

