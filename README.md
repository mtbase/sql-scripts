# SQL-Scripts

This repository contains the necessary scripts forschema and data loading for
the MT-H as well for the TPC-H benchmark. In addition, there are also scripts
for index creation (which is best to run AFTER data population for performance
    reasons). These scripts are part of the [MTBase
    project](https://github.com/mtbase/overview).


## Loading Schema, Data and Indexes for MT-H

For loading the schema, data and indexes for a given PostgreSQL (MySql)
database, perform the following steps:
 1. download, compile and execute the [MT-H data
    generator](https://github.com/mtbase/mt-h)
 2. execute `schema_mth.sql`
 3. execute `udfs_postgres_mth.sql` (`udfs_mysql_mth.sql`)
 4. execute `population_postgres_mth.sql` (`population_mysql_mth.sql`)
 5. execute `idx_mth.sql`

## Loading Schema, Data and Indexes for TPC-H

TPC-H (with the same scaling factor) is a good baseline to benchmark MT-H
against. Hence, the following scripts might be useful to load schema, data, and
indexes:
 1. download, compile and execute the [TPC-H
    dbgen](https://github.com/airlift/tpch)
 2. execute `schema_tpch.sql`
 3. execute `population_postgres_tpch.sql` (`population_mysql_tpch.sql`)
 5. execute `idx_tpch.sql`

