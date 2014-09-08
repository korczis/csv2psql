# csv2psql

Tool for transforming CSV into SQL statements

*Formalities*

- [License](https://github.com/korczis/csv2psql/blob/master/LICENSE)
- [To Do](https://github.com/korczis/csv2psql/blob/master/TODO.md)
- [Issues](https://github.com/korczis/csv2psql/issues)

## Status

[![Gem Version](https://badge.fury.io/rb/csv2psql.svg)](http://badge.fury.io/rb/csv2psql) 
[![Downloads](http://img.shields.io/gem/dt/csv2psql.svg)](http://rubygems.org/gems/csv2psql)
[![Build Status](https://travis-ci.org/korczis/csv2psql.svg?branch=master)](https://travis-ci.org/korczis/csv2psql)
[![Code Climate](https://codeclimate.com/github/korczis/csv2psql/badges/gpa.svg)](https://codeclimate.com/github/korczis/csv2psql)
[![Dependency Status](https://gemnasium.com/korczis/csv2psql.svg)](https://gemnasium.com/korczis/csv2psql)
[![Coverage Status](https://coveralls.io/repos/korczis/csv2psql/badge.png?branch=master)](https://coveralls.io/r/korczis/csv2psql?branch=master)

## Features

- Works outside of box
- Customizable (parameters can be tweaked)
- Extendable (external modules can bring functionality)
- Database aware
- SQL Dialects sensitive
  - [Drop table](https://github.com/korczis/csv2psql/blob/master/templates/drop_table.sql.erb)
  - [Create table](https://github.com/korczis/csv2psql/blob/master/templates/create_table.sql.erb)
  - [Truncate database](https://github.com/korczis/csv2psql/blob/master/templates/truncate_table.sql.erb)

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
    csv2psql - csv2psql 0.0.11 (Codename: Famous rat)

SYNOPSIS
    csv2psql [global options] command [command options] [arguments...]

GLOBAL OPTIONS
    -d, --delimiter=arg - Column delimiter (default: ,)
    -h, --[no-]header   - Header row included (default: enabled)
    --help              - Show this message
    -l, --limit=arg     - How many rows process (default: -1)
    -q, --quote=arg     - Quoting character (default: ")
    -s, --separator=arg - Line separator (default: none)
    --skip=arg          - How many rows skip (default: -1)

COMMANDS
    analyze - Analyze csv file
    convert - Convert csv file
    help    - Shows a list of commands or help for one command
    version - Print version info
```

**Analyze help**

```
csv2psql help analyze

NAME
    analyze - Analyze csv file

SYNOPSIS
    csv2psql [global options] analyze [command options]

COMMAND OPTIONS
    -f, --format=arg - Output format (default: json)
```

**Convert help**

```
csv2psql help convert

NAME
    convert - Convert csv file

SYNOPSIS
    csv2psql [global options] convert [command options]

COMMAND OPTIONS
    --[no-]create-table   - Crate SQL Table before inserts
    --[no-]drop-table     - Drop SQL Table before inserts
    -t, --table=arg       - Table to insert to (default: none)
    --[no-]transaction    - Import in transaction block (default: enabled)
    --[no-]truncate-table - Truncate SQL Table before inserts
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
-- Table: my_table

INSERT INTO (id, firstname, lastname, address_street, address_city, address_details_note) VALUES('12345', 'Joe', 'Doe', '#2140 Taylor Street, 94133', 'San Francisco', 'Pool available');
INSERT INTO (id, firstname, lastname, address_street, address_city, address_details_note) VALUES('45678', 'Jack', 'Plumber', '#111 Sutter St, 94104', 'San Francisco', 'Korean Deli near to main entrance');
COMMIT;
```

**Convert CSV - Create table**

```
csv2psql convert --create-table -t pokus data/sample.csv

BEGIN;
-- Table: pokus

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

**Convert CSV - Stream directly to Postgres client (psql)**

```
csv2psql convert --create-table -t hokus data/sample.csv | psql

BEGIN
CREATE TABLE
INSERT 0 1
INSERT 0 1
COMMIT
```

**Convert CSV - Full load**

```
csv2psql convert --create-table --drop-table --truncate-table -t test data/sample.csv

BEGIN;
DROP TABLE IF EXISTS test;

CREATE TABLE test(
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

TRUNCATE test;

INSERT INTO test(id, firstname, lastname, address_street, address_city, address_details_note) VALUES('12345', 'Joe', 'Doe', '#2140 Taylor Street, 94133', 'San Francisco', 'Pool available');
INSERT INTO test(id, firstname, lastname, address_street, address_city, address_details_note) VALUES('45678', 'Jack', 'Plumber', '#111 Sutter St, 94104', 'San Francisco', 'Korean Deli near to main entrance');
COMMIT;
```

**Convert CSV - Load CIA Factbook automagically**

```
csv2psql convert --create-table --drop-table --truncate-table --no-transaction -t test data/cia-data-all.csv | psql
```

**Analyze CSV - Show as table**

```
csv2psql analyze --format=table tmp/sfpd_incident_2013.csv

+------------+--------+-----------+---------+------+--------+------+
|                    tmp/sfpd_incident_2013.csv                    |
+------------+--------+-----------+---------+------+--------+------+
| column     | Bigint | Character | Decimal | Null | String | Uuid |
+------------+--------+-----------+---------+------+--------+------+
| IncidntNum | 132145 | 0         | 0       | 0    | 132145 | 0    |
| Category   | 0      | 0         | 0       | 0    | 132145 | 0    |
| Descript   | 0      | 0         | 0       | 0    | 132145 | 0    |
| DayOfWeek  | 0      | 0         | 0       | 0    | 132145 | 0    |
| Date       | 0      | 0         | 0       | 0    | 132145 | 0    |
| Time       | 0      | 0         | 0       | 0    | 132145 | 0    |
| PdDistrict | 0      | 0         | 0       | 0    | 132145 | 0    |
| Resolution | 0      | 0         | 0       | 0    | 132145 | 0    |
| Location   | 0      | 0         | 0       | 0    | 132145 | 0    |
| X          | 0      | 0         | 132145  | 0    | 132145 | 0    |
| Y          | 0      | 0         | 132145  | 0    | 132145 | 0    |
+------------+--------+-----------+---------+------+--------+------+
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

Copyright (c) 2014 [Tomas Korcak](https://www.linkedin.com/in/korcaktomas). See [LICENSE](https://github.com/korczis/csv2psql/blob/master/LICENSE) for details.
