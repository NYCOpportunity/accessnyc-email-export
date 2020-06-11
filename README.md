# ACCESS NYC Emails Script

A Ruby script to automate the process of retrieveing emails from ACCESS database
and upload to Box.com as a CSV file.

# Requirements

NOTE: This application uses Ruby version 2.5.8 make sure you have Ruby installed
for more information [following
documentation](https://www.ruby-lang.org/en/documentation/installation/)

Make sure to have MYSQL install and OpenSSL.

```
brew install mysql
brew install openssl
```

# Installation

```
cd ACCESS-NYC-emails-script
bundle install
```

NOTE: If you get the following mysql2 error message:

```
An error occurred while installing mysql2 (0.5.2), and Bundler cannot continue.
Make sure that `gem install mysql2 -v '0.5.2' --source 'https://rubygems.org/'` succeeds before bundling.
```

install the gem with the following command:

```
gem install mysql2 -v '0.5.2' -- --with-ldflags=-L/usr/local/opt/openssl/lib --with-cppflags=-I/usr/local/opt/openssl/include
```

and run `bundle install` again.

# Run

To run the script you need to pass 3 arguments Year Month Day. These arguments
represent the starting date from which you want the emails to be retrieve. For
example, if you add 2020 06 01, all the emails from 2020/06/01 till now will be
added to the CSV file that is uploaded to Box.com

```
ruby lambda_function.rb YYYY MM DD
```
NOTE: input has to be numbers with a space example:

```
ruby lambda_function.rb 2020 06 01
```


# Issues

Open up an issue if you encounter a problem.
