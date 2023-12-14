#!/bin/bash

psql -U postgres -c "CREATE DATABASE contoso"
psql --dbname=contoso --username=postgres -f /docker-entrypoint-initdb.d/sqlfiles/create_tables_erdplus.sql
psql --dbname=contoso --username=postgres -f /docker-entrypoint-initdb.d/sqlfiles/insert_data2tables.sql
#
#
#
