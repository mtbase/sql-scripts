-- Database Schema for MT Benchmark. 
-- (c) 2016 @braunl @marenato

ALTER TABLE CurrencyTransform ADD PRIMARY KEY (CT_currency_key);

ALTER TABLE PhoneTransform ADD PRIMARY KEY (PT_phone_prefix_key);

ALTER TABLE Tenant  ADD PRIMARY KEY (T_tenant_key);

ALTER TABLE Region ADD PRIMARY KEY (R_regionkey); 

ALTER TABLE Nation ADD PRIMARY KEY (N_nationkey);

ALTER TABLE Part ADD PRIMARY KEY (P_partkey);

ALTER TABLE Supplier ADD PRIMARY KEY (S_suppkey);

ALTER TABLE Partsupp ADD PRIMARY KEY (PS_partkey, PS_suppkey);
ALTER TABLE Partsupp ADD FOREIGN KEY(PS_partkey) REFERENCES Part(P_partkey);
ALTER TABLE Partsupp ADD FOREIGN KEY (PS_suppkey) REFERENCES Supplier(S_suppkey);

CREATE INDEX PS_part_index ON Partsupp (PS_partkey);
CREATE INDEX PS_supp_index ON Partsupp (PS_suppkey);

ALTER TABLE Customer ADD PRIMARY KEY (Customer_tenant_key, C_custkey);
ALTER TABLE Customer ADD FOREIGN KEY (C_nationkey) REFERENCES Nation(N_nationkey);
ALTER TABLE Customer ADD FOREIGN KEY (Customer_tenant_key) REFERENCES Tenant(T_tenant_key);

CREATE INDEX C_nation_index ON Customer (C_nationkey);

ALTER TABLE Orders ADD PRIMARY KEY (Orders_tenant_key, O_orderkey);
ALTER TABLE Orders ADD FOREIGN KEY (Orders_tenant_key, O_custkey) REFERENCES Customer(Customer_tenant_key, C_custkey);
ALTER TABLE Orders ADD FOREIGN KEY (Orders_tenant_key) REFERENCES Tenant(T_tenant_key);

CREATE INDEX O_cust_index ON Orders(Orders_tenant_key, O_custkey);

ALTER TABLE Lineitem ADD PRIMARY KEY(Lineitem_tenant_key, L_orderkey, L_linenumber);
ALTER TABLE Lineitem ADD FOREIGN KEY (Lineitem_tenant_key, L_orderkey) REFERENCES Orders(Orders_tenant_key, O_orderkey);
ALTER TABLE Lineitem ADD FOREIGN KEY (L_partkey, L_suppkey) REFERENCES Partsupp(PS_partkey, PS_suppkey);
ALTER TABLE Lineitem ADD FOREIGN KEY (Lineitem_tenant_key) REFERENCES Tenant(T_tenant_key);

CREATE INDEX L_PARTSUPP_INDEX ON Lineitem (L_partkey, L_suppkey);

CREATE tablespace temp_tbs location '/run/shm/pgTmp';
SET temp_tablespaces = temp_tbs;
SELECT pg_reload_conf();
