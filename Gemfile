source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.1.2"

gem "rails", "~> 7.0.3", ">= 7.0.3.1"
gem "sprockets-rails"
gem "sqlite3", "~> 1.4"
gem "puma", "~> 5.0"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "jbuilder"
gem "devise"
gem 'bootstrap-sass'
gem "tzinfo-data"
gem "tzinfo"
gem "bootsnap", require: false
gem "rspec"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem 'rspec-rails'
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
  gem 'rails-controller-testing'
end

gem "debug"

gem 'pry'
gem 'pry-remote'
gem 'pry-nav'

group :development do
  gem "web-console"
end

group :test do
gem 'rspec-rails'
  gem "capybara"
  gem "selenium-webdriver"
  gem "webdrivers"
end
