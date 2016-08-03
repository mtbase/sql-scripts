-- UDF conversion functions for MT Benchmark. 
-- (c) 2016 @braunl @marenato

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

