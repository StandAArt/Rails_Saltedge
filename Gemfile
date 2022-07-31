source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.1.2"

gem "bootsnap", require: false
gem "bootstrap-sass"
gem "devise"
gem "importmap-rails"
gem "jbuilder"
gem "puma", "~> 5.0"
gem "rails", "~> 7.0.3", ">= 7.0.3.1"
gem "rspec"
gem "rubocop", require: false
gem "sprockets-rails"
gem "stimulus-rails"
gem "turbo-rails"
gem "tzinfo"
gem "tzinfo-data"

group :production do
  gem "pg"
  gem "rails_12factor"
end

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[mri mingw x64_mingw]
  gem "rails-controller-testing"
  gem "rspec-rails"
  gem "sqlite3", "~> 1.4"
end

gem "debug"

gem "pry"
gem "pry-nav"
gem "pry-remote"
gem "rufus-scheduler"

group :development do
  gem "web-console"
end

group :test do
  gem "capybara"
  gem "rspec-rails"
  gem "selenium-webdriver"
  gem "webdrivers"
end
