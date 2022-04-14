# ACCESS NYC Email Export

A Ruby script to automate the process of retrieving emails from the [ACCESS NYC Stat Collector](https://github.com/CityOfNewYork/nyco-wp-stat-collector) database. It will export a CSV with emails from a remote database. The CSV will save to a local directory of your choosing.

## Requirements

* [Ruby](https://www.ruby-lang.org) **v2.5.8**
* [MySQL](https://www.mysql.com)
* [OpenSSL](https://www.openssl.org)

This application uses Ruby version **v2.5.8**. For more information on installing Ruby refer to the [following documentation](https://www.ruby-lang.org/en/documentation/installation/). Ruby versions can be managed using [Ruby Version Manager](https://rvm.io/).

Make sure to have [MySQL](https://www.mysql.com/) installed and [OpenSSL](https://www.openssl.org/) (which can be done using [Homebrew](https://brew.sh/) for MacOS).

```shell
brew install mysql && brew install openssl
```

## Installation

```shell
cd ACCESS-NYC-emails-script
bundle install
```

If you get the following mysql2 error message:

```shell
An error occurred while installing mysql2 (0.5.2), and Bundler cannot continue.
Make sure that `gem install mysql2 -v '0.5.2' --source 'https://rubygems.org/'` succeeds before bundling.
```

Install the gem with the following command:

```shell
gem install mysql2 -v '0.5.2' -- --with-ldflags=-L/usr/local/opt/openssl/lib --with-cppflags=-I/usr/local/opt/openssl/include
```

Then, run `bundle install` again.

## Usage

Fill in the following constants in a **.env** file in the root of the script. The value for each constant is a string:

Constant      | Description
--------------|-
`DB_HOSTNAME` | The host of the database to export from.
`DB_NAME`     | The name of the database to export from.
`DB_USERNAME` | Username for the database.
`DB_PW`       | Password for the database.
`LOCAL_PATH`  | The local path to save the exported CSV to.
`LOG_LEVEL`   | This may be set to `DEBUG` for troubleshooting.

The script accepts three arguments for the year, month, and day representing the date to start the range of exported emails. The range will end at the time the script runs.

```shell
ruby lambda_function.rb {{ MM }} {{ DD }} {{ YYYY }}
```

Replace `{{ MM }}`, `{{ DD }}`, `{{ YYYY }}` with the **month**, **day**, and **year** respectively.

```shell
ruby lambda_function.rb 06 01 2020
```

A CSV titled **access-nyc-emails-{{ script run date }}.csv** will be saved to the directory specified in the `LOCAL_PATH` constant with email entries starting on 06/01/2020 and ending on the date the script ran.
