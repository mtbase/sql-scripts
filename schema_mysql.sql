-- Database Schema for MT Benchmark. User-defined functions were written in the MySql-5.6 dialect. All other statements are valid SQL.
-- (c) 2016 @braunl

-- Conversion Tables

CREATE TABLE CurrencyTransform (
  CT_currency_key       INTEGER NOT NULL,
  CT_to_universal       DECIMAL(6,4) NOT NULL,
  CT_from_universal     DECIMAL(6,4) NOT NULL,
  CONSTRAINT pk_currency_key PRIMARY KEY (CT_currency_key)
) ENGINE=InnoDB;

CREATE UNIQUE INDEX CT_index ON CurrencyTransform (CT_currency_key);

CREATE TABLE PhoneTransform (
  PT_phone_prefix_key   INTEGER NOT NULL,
  PT_prefix             VARCHAR(2),
  CONSTRAINT pk_phone_prefix_key PRIMARY KEY (PT_phone_prefix_key)
) ENGINE=InnoDB;

CREATE UNIQUE INDEX PT_index ON PhoneTransform (PT_phone_prefix_key);

-- Tenant Table
CREATE TABLE Tenant (
  T_tenant_key          INTEGER NOT NULL,
  T_tenant_name         VARCHAR(25) NOT NULL,
  T_currency_key        INTEGER NOT NULL,
  T_phone_prefix_key    INTEGER NOT NULL,
  CONSTRAINT pk_tenant_key PRIMARY KEY (T_tenant_key),
  CONSTRAINT fk_currency_key FOREIGN KEY (T_currency_key) REFERENCES CurrencyTransform(CT_currency_key),
  CONSTRAINT fk_phone_prefix_key FOREIGN KEY (T_phone_prefix_key) REFERENCES PhoneTransform(PT_phone_prefix_key)
) ENGINE=InnoDB;

CREATE UNIQUE INDEX T_index ON Tenant (T_tenant_key);

-- Converion Functions (using mysql syntax)

DELIMITER $$

CREATE FUNCTION currencyToUniversal (currency DECIMAL(15,2), tenantKey INTEGER) RETURNS DECIMAL(15,2)
    BEGIN
    RETURN (SELECT CT_to_universal*currency FROM Tenant, CurrencyTransform WHERE T_tenant_key = tenantKey AND T_currency_key = CT_currency_key);
END $$

CREATE FUNCTION currencyFromUniversal (currency DECIMAL(15,2), tenantKey INTEGER) RETURNS DECIMAL(15,2)
    BEGIN
    RETURN (SELECT CT_from_universal*currency FROM Tenant, CurrencyTransform WHERE T_tenant_key = tenantKey AND T_currency_key = CT_currency_key);
END $$

CREATE FUNCTION phoneToUniversal (phone VARCHAR(17), tenantKey INTEGER) RETURNS VARCHAR(17)
    BEGIN
    RETURN (SELECT SUBSTRING(phone, CHAR_LENGTH(PT_prefix)+1) FROM Tenant, PhoneTransform WHERE T_tenant_key = tenantKey AND T_phone_prefix_key = PT_phone_prefix_key);
END $$

CREATE FUNCTION phoneFromUniversal (phone VARCHAR(17), tenantKey INTEGER) RETURNS VARCHAR(17)
    BEGIN
    RETURN (SELECT CONCAT(PT_prefix, phone) FROM Tenant, PhoneTransform WHERE T_tenant_key = tenantKey AND T_phone_prefix_key = PT_phone_prefix_key);
END $$

DELIMITER ;

-- Shared Tables

CREATE TABLE Region (
  R_regionkey  INTEGER NOT NULL,
  R_name       CHAR(25) NOT NULL,
  R_comment    VARCHAR(152),
  CONSTRAINT pk_regionkey PRIMARY KEY (R_regionkey)
) ENGINE=InnoDB;

CREATE UNIQUE INDEX R_index ON Region (R_regionkey);

CREATE TABLE Nation (
  N_nationkey  INTEGER NOT NULL,
  N_name       CHAR(25) NOT NULL,
  N_regionkey  INTEGER NOT NULL,
  N_comment    VARCHAR(152),
  CONSTRAINT pk_nationkey PRIMARY KEY (N_nationkey)
) ENGINE=InnoDB;

CREATE UNIQUE INDEX N_index ON Nation (N_nationkey);

-- Specific Tables

CREATE TABLE Part (
  P_partkey     INTEGER NOT NULL,
  P_name        VARCHAR(55) NOT NULL,
  P_mfgr        CHAR(25) NOT NULL,
  P_brand       CHAR(10) NOT NULL,
  P_type        VARCHAR(25) NOT NULL,
  P_size        INTEGER NOT NULL,
  P_container   CHAR(10) NOT NULL,
  P_retailprice DECIMAL(15,2) NOT NULL,
  P_comment     VARCHAR(23) NOT NULL,
  CONSTRAINT pk_partkey PRIMARY KEY (P_partkey)
) ENGINE=InnoDB;

CREATE UNIQUE INDEX P_index ON Part (P_partkey);

CREATE TABLE Supplier (
  S_suppkey     INTEGER NOT NULL,
  S_name        CHAR(25) NOT NULL,
  S_address     VARCHAR(40) NOT NULL,
  S_nationkey   INTEGER NOT NULL,
  S_phone       VARCHAR(17) NOT NULL,
  S_acctbal     DECIMAL(15,2) NOT NULL,
  S_comment     VARCHAR(101) NOT NULL,
  CONSTRAINT pk_suppkey PRIMARY KEY (S_suppkey)
) ENGINE=InnoDB;

CREATE UNIQUE INDEX S_index ON Supplier (S_suppkey);

CREATE TABLE Partsupp (
  PS_partkey     INTEGER NOT NULL,
  PS_suppkey     INTEGER NOT NULL,
  PS_availqty    INTEGER NOT NULL,
  PS_supplycost  DECIMAL(15,2)  NOT NULL,
  PS_comment     VARCHAR(199) NOT NULL,
  CONSTRAINT pk_partsupp PRIMARY KEY (PS_partkey, PS_suppkey),
  CONSTRAINT fk_partkey FOREIGN KEY (PS_partkey) REFERENCES Part(P_partkey),
  CONSTRAINT fk_suppkey FOREIGN KEY (PS_suppkey) REFERENCES Supplier(S_suppkey)
) ENGINE=InnoDB;

CREATE UNIQUE INDEX PS_index ON Partsupp (PS_partkey, PS_suppkey);
CREATE INDEX PS_part_index ON Partsupp (PS_partkey);
CREATE INDEX PS_supp_index ON Partsupp (PS_suppkey);
                        
CREATE TABLE Customer (
  Customer_tenant_key INTEGER NOT NULL,
  C_custkey           INTEGER NOT NULL,
  C_name              VARCHAR(25) NOT NULL,
  C_address           VARCHAR(40) NOT NULL,
  C_nationkey         INTEGER NOT NULL,
  C_phone             VARCHAR(17) NOT NULL,
  C_acctbal           DECIMAL(15,2)   NOT NULL,
  C_mktsegment        CHAR(10) NOT NULL,
  C_comment           VARCHAR(117) NOT NULL,
  CONSTRAINT pk_custkey PRIMARY KEY (Customer_tenant_key, C_custkey),
  CONSTRAINT fk_nationkey FOREIGN KEY (C_nationkey) REFERENCES Nation(N_nationkey),
  CONSTRAINT fk_tenantkey FOREIGN KEY (Customer_tenant_key) REFERENCES Tenant(T_tenant_key)
) ENGINE=InnoDB;

CREATE UNIQUE INDEX C_index ON Customer (Customer_tenant_key, C_custkey);
CREATE INDEX C_nation_index ON Customer (C_nationkey);

CREATE TABLE Orders  (
  Orders_tenant_key INTEGER NOT NULL,
  O_orderkey        INTEGER NOT NULL,
  O_custkey         INTEGER NOT NULL,
  O_orderstatus     CHAR(1) NOT NULL,
  O_totalprice      DECIMAL(15,2) NOT NULL,
  O_orderdate       DATE NOT NULL,
  O_orderpriority   CHAR(15) NOT NULL,  
  O_clerk           CHAR(15) NOT NULL, 
  O_shippriority    INTEGER NOT NULL,
  O_comment         VARCHAR(79) NOT NULL,
  CONSTRAINT pk_orderkey PRIMARY KEY (Orders_tenant_key, O_orderkey),
  CONSTRAINT fk_custkey FOREIGN KEY (Orders_tenant_key, O_custkey) REFERENCES Customer(Customer_tenant_key, C_custkey)
) ENGINE=InnoDB;

CREATE UNIQUE INDEX O_index ON Orders (Orders_tenant_key, O_orderkey);
CREATE INDEX O_cust_index ON Orders(Orders_tenant_key, O_custkey);

CREATE TABLE Lineitem (
  Lineitem_tenant_key INTEGER NOT NULL,
  L_orderkey          INTEGER NOT NULL,
  L_partkey           INTEGER NOT NULL,
  L_suppkey           INTEGER NOT NULL,
  L_linenumber        INTEGER NOT NULL,
  L_quantity          DECIMAL(15,2) NOT NULL,
  L_extendedprice     DECIMAL(15,2) NOT NULL,
  L_discount          DECIMAL(15,2) NOT NULL,
  L_tax               DECIMAL(15,2) NOT NULL,
  L_returnflag        CHAR(1) NOT NULL,
  L_linestatus        CHAR(1) NOT NULL,
  L_shipdate          DATE NOT NULL,
  L_commitdate        DATE NOT NULL,
  L_receiptdate       DATE NOT NULL,
  L_shipinstruct      CHAR(25) NOT NULL,
  L_shipmode          CHAR(10) NOT NULL,
  L_comment           VARCHAR(44) NOT NULL,
  CONSTRAINT pk_lineitem PRIMARY KEY (Lineitem_tenant_key, L_orderkey, L_linenumber),
  CONSTRAINT fk_orderkey FOREIGN KEY (Lineitem_tenant_key, L_orderkey) REFERENCES Orders(Orders_tenant_key, O_orderkey),
  CONSTRAINT fk_partsupp FOREIGN KEY (L_partkey, L_suppkey) REFERENCES Partsupp(PS_partkey, PS_suppkey)
) ENGINE=InnoDB;

CREATE UNIQUE INDEX L_INDEX ON Lineitem (Lineitem_tenant_key, L_orderkey, L_linenumber);
CREATE INDEX L_PARTSUPP_INDEX ON Lineitem (L_partkey, L_suppkey);

