# Rails 6.1 JSON template

Basic template to help me spin up a rails app quickly

## Usage

One liner:

    $ rails new <app_name> --api -T -d postgresql -m https://raw.githubusercontent.com/richo225/api_template/master/template.rb

OR

Clone the repo:

    $ git clone git@github.com:richo225/api_template.git

Create your rails app using the template:

    $ rails new <app_name> --api -T -d postgresql -m ./api_template/template.rb

## Features

* PostgreSQL database
* FactoryBot
* Faker
* HTTParty
* Rubocop linter
* RSpec setup
* Devise token authentication
* Docker

## TODO

- [ ] Heroku deployment
- [ ] CircleCI setup
- [ ] Coveralls/test coverage
- [ ] Replace `devise_token_auth` as it does not support ruby >=2.5 and hence rails 7
