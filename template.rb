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

# Setup devise
generate 'devise_token_auth:install'
rails_command 'db:migrate'
