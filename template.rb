# frozen_string_literal: true

insert_into_file '.gitignore', '/config/credentials.yml.enc'

# Initialise git
git :init
git add: "."
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
gem 'rspec-rails', '~> 3.7.2'

bundle install
