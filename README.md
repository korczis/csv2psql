# csv2psql

Tool for transforming CSV into SQL statements

## Status

[![Gem Version](https://badge.fury.io/rb/csv2psql.svg)](http://badge.fury.io/rb/csv2psql) 
[![Downloads](http://img.shields.io/gem/dt/csv2psql.svg)](http://rubygems.org/gems/csv2psql)
[![Build Status](https://travis-ci.org/korczis/csv2psql.svg?branch=master)](https://travis-ci.org/korczis/csv2psql)
[![Code Climate](https://codeclimate.com/github/korczis/csv2psql/badges/gpa.svg)](https://codeclimate.com/github/korczis/csv2psql)
[![Dependency Status](https://gemnasium.com/korczis/csv2psql.svg)](https://gemnasium.com/korczis/csv2psql)

## Getting started 

```
gem install csv2psql
```

## Usage

**Simple conversion**

```
csv2psql convert data/sample.csv
```

**Global help**

```
csv2psql help

NAME
    csv2psql - csv2psql 0.0.5

SYNOPSIS
    csv2psql [global options] command [command options] [arguments...]

GLOBAL OPTIONS
    --help - Show this message

COMMANDS
    convert - Convert csv file
    help    - Shows a list of commands or help for one command
    version - Print version info
```

**Convert help**

```
csv2psql help convert

NAME
    convert - Convert csv file

SYNOPSIS
    csv2psql [global options] convert [command options]

COMMAND OPTIONS
    --[no-]create-table - Crate SQL Table before inserts
    -d, --delimiter=arg - Column delimiter (default: ,)
    -h, --[no-]header   - Header row included (default: enabled)
    -q, --quote=arg     - Quoting character (default: ")
    -s, --separator=arg - Line separator (default: auto)
    -t, --table=arg     - Table to insert to (default: my_table)
    --[no-]transaction  - Import in transaction block (default: enabled)
```

## Example

**Input CSV**

```
cat data/sample.csv

id,Firstname,Lastname,Address.Street,Address.City,Address.Details.Note
12345,Joe,Doe,"#2140 Taylor Street, 94133",San Francisco,Pool available
45678,Jack,Plumber,"#111 Sutter St, 94104",San Francisco,Korean Deli near to main entrance
```

**Convert CSV**

```
csv2psql convert data/sample.csv

BEGIN;
INSERT INTO my_table(id, firstname, lastname, address_street, address_city, address_details_note) VALUES('12345', 'Joe', 'Doe', '#2140 Taylor Street, 94133', 'San Francisco', 'Pool available');
INSERT INTO my_table(id, firstname, lastname, address_street, address_city, address_details_note) VALUES('45678', 'Jack', 'Plumber', '#111 Sutter St, 94104', 'San Francisco', 'Korean Deli near to main entrance');
COMMIT;
```

**Convert CSV - Create table**

```
csv2psql convert --create-table -t pokus data/sample.csv

BEGIN;
-- Table: pokus
-- DROP TABLE pokus;

CREATE TABLE pokus(
	id TEXT,
	firstname TEXT,
	lastname TEXT,
	address_street TEXT,
	address_city TEXT,
	address_details_note TEXT
)
WITH (
  OIDS=FALSE
);

INSERT INTO pokus(id, firstname, lastname, address_street, address_city, address_details_note) VALUES('12345', 'Joe', 'Doe', '#2140 Taylor Street, 94133', 'San Francisco', 'Pool available');
INSERT INTO pokus(id, firstname, lastname, address_street, address_city, address_details_note) VALUES('45678', 'Jack', 'Plumber', '#111 Sutter St, 94104', 'San Francisco', 'Korean Deli near to main entrance');
COMMIT;
```

**Convert CSV - Stream directly to Postgre client (psql)**

```
csv2psql convert --create-table -t hokus data/sample.csv | psql -h apollocrawler.com -U datathon
BEGIN
CREATE TABLE
INSERT 0 1
INSERT 0 1
COMMIT
```

## Contributing to csv2psql

- Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
- Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
- Fork the project
- Start a feature/bugfix branch
- Commit and push until you are happy with your contribution
- Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
- Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2014 Tomas Korcak. See LICENSE for details.
