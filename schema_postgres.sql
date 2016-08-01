-- Database Schema for MT Benchmark. 
-- (c) 2016 @braunl @marenato

-- Conversion Tables

CREATE TABLE CurrencyTransform (
  CT_currency_key       INTEGER NOT NULL,
  CT_to_universal       DECIMAL(6,4) NOT NULL,
  CT_from_universal     DECIMAL(6,4) NOT NULL
);

-- PostgreSQL automatically creates a unique index when a unique constraint or primary key is defined for a table
-- https://www.postgresql.org/docs/9.5/static/indexes-unique.html

CREATE TABLE PhoneTransform (
  PT_phone_prefix_key   INTEGER NOT NULL,
  PT_prefix             VARCHAR(2)
);

-- Tenant Table
CREATE TABLE Tenant (
  T_tenant_key          INTEGER NOT NULL,
  T_tenant_name         VARCHAR(25) NOT NULL,
  T_currency_key        INTEGER NOT NULL,
  T_phone_prefix_key    INTEGER NOT NULL
);

-- Converion Functions

CREATE FUNCTION currencyToUniversal (DECIMAL(15,2), INTEGER) RETURNS DECIMAL(15,2)
    AS 'SELECT CT_to_universal*$1 FROM Tenant, CurrencyTransform WHERE T_tenant_key = $2 AND T_currency_key = CT_currency_key;'
    LANGUAGE SQL
    IMMUTABLE;

CREATE FUNCTION currencyFromUniversal (DECIMAL(15,2), INTEGER) RETURNS DECIMAL(15,2)
    AS 'SELECT CT_from_universal*$1 FROM Tenant, CurrencyTransform WHERE T_tenant_key = $2 AND T_currency_key = CT_currency_key;'
    LANGUAGE SQL
    IMMUTABLE;

CREATE FUNCTION phoneToUniversal (VARCHAR(17), INTEGER) RETURNS VARCHAR(17)
    AS 'SELECT SUBSTRING($1, CHAR_LENGTH(PT_prefix)+1) FROM Tenant, PhoneTransform WHERE T_tenant_key = $2 AND T_phone_prefix_key = PT_phone_prefix_key;'
    LANGUAGE SQL
    IMMUTABLE;

CREATE FUNCTION phoneFromUniversal (VARCHAR(17), INTEGER) RETURNS VARCHAR(17)
    AS 'SELECT CONCAT(PT_prefix, $1) FROM Tenant, PhoneTransform WHERE T_tenant_key = $2 AND T_phone_prefix_key = PT_phone_prefix_key;'
    LANGUAGE SQL
    IMMUTABLE;

-- Shared Tables

CREATE TABLE Region (
  R_regionkey  INTEGER NOT NULL,
  R_name       CHAR(25) NOT NULL,
  R_comment    VARCHAR(152)
);

CREATE TABLE Nation (
  N_nationkey  INTEGER NOT NULL,
  N_name       CHAR(25) NOT NULL,
  N_regionkey  INTEGER NOT NULL,
  N_comment    VARCHAR(152)
);

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
  P_comment     VARCHAR(23) NOT NULL
);

CREATE TABLE Supplier (
  S_suppkey     INTEGER NOT NULL,
  S_name        CHAR(25) NOT NULL,
  S_address     VARCHAR(40) NOT NULL,
  S_nationkey   INTEGER NOT NULL,
  S_phone       VARCHAR(17) NOT NULL,
  S_acctbal     DECIMAL(15,2) NOT NULL,
  S_comment     VARCHAR(101) NOT NULL
);

CREATE TABLE Partsupp (
  PS_partkey     INTEGER NOT NULL,
  PS_suppkey     INTEGER NOT NULL,
  PS_availqty    INTEGER NOT NULL,
  PS_supplycost  DECIMAL(15,2)  NOT NULL,
  PS_comment     VARCHAR(199) NOT NULL
);

CREATE TABLE Customer (
  Customer_tenant_key INTEGER NOT NULL,
  C_custkey           INTEGER NOT NULL,
  C_name              VARCHAR(25) NOT NULL,
  C_address           VARCHAR(40) NOT NULL,
  C_nationkey         INTEGER NOT NULL,
  C_phone             VARCHAR(17) NOT NULL,
  C_acctbal           DECIMAL(15,2)   NOT NULL,
  C_mktsegment        CHAR(10) NOT NULL,
  C_comment           VARCHAR(117) NOT NULL
);

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
  O_comment         VARCHAR(79) NOT NULL
);

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
  L_comment           VARCHAR(44) NOT NULL
);

