-- script for loading MT-H data into PostgreSQL
-- (c) 2016 @braunl
-- adjust data paths and files as needed

COPY CurrencyTransform  FROM 'currency.tbl'     INTO TABLE   DELIMITER '|' csv;
COPY PhoneTransform     FROM 'phone.tbl'        INTO TABLE   DELIMITER '|' csv;
COPY Tenant             FROM 'tenant.tbl'       INTO TABLE   DELIMITER '|' csv;
COPY Region             FROM 'region.tbl.1'     INTO TABLE   DELIMITER '|' csv;
COPY Nation             FROM 'nation.tbl.1'     INTO TABLE   DELIMITER '|' csv;
COPY Part               FROM 'part.tbl.1'       INTO TABLE   DELIMITER '|' csv;
COPY Supplier           FROM 'supplier.tbl.1'   INTO TABLE   DELIMITER '|' csv;
COPY Partsupp           FROM 'partsupp.tbl.1'   INTO TABLE   DELIMITER '|' csv;
COPY Customer           FROM 'customer.tbl.1'   INTO TABLE   DELIMITER '|' csv;
COPY Orders             FROM 'orders.tbl.1'     INTO TABLE   DELIMITER '|' csv;
COPY Lineitem           FROM 'lineitem.tbl.1'   INTO TABLE   DELIMITER '|' csv;

