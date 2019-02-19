# frozen_string_literal: true

append_to_file '.gitignore', <<~GITIGNORE
  /config/credentials.yml
  /config/database.yml
  .env
GITIGNORE

# Initialise git
git :init
git add: '.'
git commit: "-m 'Initial commit'"

# Setup gems
gem_group :development, :test do
  gem 'coveralls', require: false
  gem 'cucumber-rails', require: false
  gem 'database_cleaner'
  gem 'factory_bot_rails'
  gem 'faker', '~> 1.9.1'
  gem 'pry'
  gem 'pry-byebug'
  gem 'shoulda-matchers'
  gem 'rspec-rails', '~> 3.7.2'
end

gem_group :development do
  gem 'rubocop', require: false
end

gem 'devise_token_auth'
gem 'dotenv-rails'
gem 'httparty', '~> 0.16.2'
gem 'omniauth-github'
gem 'omniauth-facebook'
gem 'omniauth-google-oauth2'

# Setup database
remove_file 'config/databse.yml'
create_file 'config/database.yml', <<~DATABASE
  # PostgreSQL. Versions 9.1 and up are supported.

  default: &default
    adapter: postgresql
    encoding: unicode
    username: postgres
    password:
    host: localhost
    # For details on connection pooling, see rails configuration guide
    # http://guides.rubyonrails.org/configuring.html#database-pooling
    pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>

  development:
    <<: *default
    database: #{app_name}_development

    # The specified database role being used to connect to postgres.
    # To create additional roles in postgres see `$ createuser --help`.
    # When left blank, postgres will use the default role. This is
    # the same name as the operating system user that initialized the database.
    #username: #{app_name}

    # The password associated with the postgres role (username).
    #password:

    # Connect on a TCP socket. Omitted by default since the client uses a
    # domain socket that doesn't need configuration. Windows does not have
    # domain sockets, so uncomment these lines.
    #host: localhost

    # The TCP port the server listens on. Defaults to 5432.
    # If your server runs on a different port number, change accordingly.
    #port: 5432

    # Schema search path. The server defaults to $user,public
    #schema_search_path: myapp,sharedapp,public

    # Minimum log levels, in increasing order:
    #   debug5, debug4, debug3, debug2, debug1,
    #   log, notice, warning, error, fatal, and panic
    # Defaults to warning.
    #min_messages: notice

  # Warning: The database defined as "test" will be erased and
  # re-generated from your development database when you run "rake".
  # Do not set this db to the same as development or production.
  test: &test
    <<: *default
    database: #{app_name}_test

  # As with config/secrets.yml, you never want to store sensitive information,
  # like your database password, in your source code. If your source code is
  # ever seen by anyone, they now have access to your database.
  #
  # Instead, provide the password as a unix environment variable when you boot
  # the app. Read http://guides.rubyonrails.org/configuring.html#configuring-a-database
  # for a full rundown on how to provide these environment variables in a
  # production deployment.
  #
  # On Heroku and other platform providers, you may have a full connection URL
  # available as an environment variable. For example:
  #
  #   DATABASE_URL="postgres://myuser:mypass@localhost/somedatabase"
  #
  # You can use this database configuration with:
  #
  #   production:
  #     url: <%= ENV['DATABASE_URL'] %>
  #
  production:
    <<: *default
    database: #{app_name}_production

  cucumber:
    <<: *test
DATABASE

rails_command 'db:setup'

# Setup dotenv
create_file '.env'

# Setup RSpec
generate 'rspec:install'

# Setup FactoryBot
create_file 'spec/support/factory_bot.rb', <<~FACTORYBOT
  RSpec.configure do |config|
    config.include FactoryBot::Syntax::Methods
  end
FACTORYBOT

insert_into_file 'spec/rails_helper.rb', after: "require 'rspec/rails'\n" do
  "require 'support/factory_bot'\n"
end

create_file 'spec/factories/user.rb', <<~USER
  FactoryBot.define do
    factory :user do
      sequence(:email) { |n| "email#{n}@mail.com" }
      password { 'StrongPassword3' }
    end
  end
USER

# Setup DatabaseCleaner
create_file 'spec/support/database_cleaner.rb', <<~CLEANER
  RSpec.configure do |config|
    config.before(:suite) do
      DatabaseCleaner.strategy = :transaction
      DatabaseCleaner.clean_with(:truncation)
    end

    config.around(:each) do |example|
      DatabaseCleaner.cleaning do
        example.run
      end
    end
  end
CLEANER

insert_into_file 'spec/rails_helper.rb', after: "require 'support/factory_bot'\n" do
  "require 'support/database_cleaner'\n"
end

# Setup shoulda matchers
create_file 'spec/support/shoulda_matchers.rb', <<~SHOULDA
  Shoulda::Matchers.configure do |config|
    config.integrate do |with|
      with.test_framework :rspec
      with.library :rails
    end
  end
SHOULDA

insert_into_file 'spec/rails_helper.rb', after: "require 'support/database_cleaner'\n" do
  "require 'support/database_cleaner'\n"
end

# Setup devise
generate 'devise_token_auth:install'
rails_command 'db:migrate'
