-- script for loading MT-H data into Mysql
-- (c) 2016 @braunl
-- adjust data paths and files as needed

LOAD DATA LOCAL INFILE 'currency.tbl'   INTO TABLE CurrencyTransform    FIELDS TERMINATED BY '|';
LOAD DATA LOCAL INFILE 'phone.tbl'      INTO TABLE PhoneTransform       FIELDS TERMINATED BY '|';
LOAD DATA LOCAL INFILE 'tenant.tbl'     INTO TABLE Tenant FIELDS        TERMINATED BY '|';
LOAD DATA LOCAL INFILE 'region.tbl.1'   INTO TABLE Region FIELDS        TERMINATED BY '|';
LOAD DATA LOCAL INFILE 'nation.tbl.1'   INTO TABLE Nation FIELDS        TERMINATED BY '|';
LOAD DATA LOCAL INFILE 'part.tbl.1'     INTO TABLE Part FIELDS          TERMINATED BY '|';
LOAD DATA LOCAL INFILE 'supplier.tbl.1' INTO TABLE Supplier FIELDS      TERMINATED BY '|';
LOAD DATA LOCAL INFILE 'partsupp.tbl.1' INTO TABLE Partsupp FIELDS      TERMINATED BY '|';
LOAD DATA LOCAL INFILE 'customer.tbl.1' INTO TABLE Customer FIELDS      TERMINATED BY '|';
LOAD DATA LOCAL INFILE 'orders.tbl.1'   INTO TABLE Orders FIELDS        TERMINATED BY '|';
LOAD DATA LOCAL INFILE 'lineitem.tbl.1' INTO TABLE Lineitem FIELDS      TERMINATED BY '|';
