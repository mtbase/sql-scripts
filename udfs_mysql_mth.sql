-- UDF conversion functions for MT Benchmark. 
-- (c) 2016 @braunl @marenato

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

