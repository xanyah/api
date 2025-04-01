# frozen_string_literal: true

source 'https://rubygems.org'

ruby '3.4.1'

# dotenv first to load environment variables everywhere
gem 'dotenv-rails', '~> 3.1', groups: %i[development test]

gem 'aasm', '~> 5.5'
gem 'active_model_serializers', '~> 0.10'
gem 'aws-sdk-s3', '~> 1.180', require: false
gem 'csv', '~> 3.3'
gem 'devise', '~> 4.9'
gem 'doorkeeper', '~> 5.8'
gem 'faker', '~> 3.5', require: false
gem 'image_processing', '~> 1.13'
gem 'money-rails', '~> 1.15'
gem 'pagy', '~> 9.3'
gem 'paranoia', '~> 3.0'
gem 'pg', '~> 1.5'
gem 'puma', '~> 6.6'
gem 'pundit', '~> 2.4'
gem 'rack-cors', '~> 2.0'
gem 'rails', '~> 8.0'
gem 'ransack', '~> 4.2'
gem 'sidekiq', '~> 7.3'
gem 'validators', '~> 3.4'

group :development, :test do
  gem 'brakeman', '~> 7.0', require: false
  gem 'database_cleaner-active_record', '~> 2.2'
  gem 'factory_bot_rails', '~> 6.4'
  gem 'pry', '~> 0.15.2'
  gem 'rspec_api_documentation', github: 'SchoolKeep/rspec_api_documentation', ref: '13df1ac'
  gem 'rubocop', '~> 1.71', require: false
  gem 'rubocop-factory_bot', '~> 2.26', require: false
  gem 'rubocop-performance', '~> 1.23', require: false
  gem 'rubocop-rails', '~> 2.31', require: false
  gem 'rubocop-rspec_rails', '~> 2.30', require: false
  gem 'rubocop-thread_safety', '~> 0.6', require: false
end

group :test do
  gem 'rspec-rails', '~> 7.1'
  gem 'rspec-sidekiq', '~> 5.0'
  gem 'simplecov', '~> 0.22'
  gem 'simplecov-console', '~> 0.4'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
