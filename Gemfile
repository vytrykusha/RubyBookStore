source "https://rubygems.org"

gem "rails", "~> 7.2.1", ">= 7.2.1.2"
gem "sprockets-rails"
gem "sqlite3", ">= 1.4", platforms: [ :ruby ]
gem "pg", "~> 1.1", platforms: [ :ruby ] # PostgreSQL for production
gem "puma", ">= 5.0"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "jbuilder"
gem "devise"
gem "tzinfo-data", platforms: %i[ windows jruby ]
gem "bootstrap", "~> 5.3.2"
gem "sassc-rails"
gem "kaminari"
gem "bootsnap", require: false
gem "rswag-api"
gem "rswag-ui"
gem "rswag-specs"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
  # Static analysis for security vulnerabilities [https://brakemanscanner.org/]
  gem "brakeman", require: false
  # Omakase Ruby styling [https://github.com/rails/rubocop-rails-omakase/]
  gem "rubocop-rails-omakase", require: false
  gem "rspec-rails"
  gem "rswag-api"
  gem "rswag-ui"
  gem "rswag-specs"
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"
  gem "rswag"
  gem "sqlite3", ">= 1.4"
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara"
  gem "selenium-webdriver"
end


# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
# Use sqlite3 as the database for Active Record
# Use the Puma web server [https://github.com/puma/puma]
# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
# Build JSON APIs with ease [https://github.com/rails/jbuilder]
# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"
# Use Redis adapter to run Action Cable in production
# gem "redis", ">= 4.0.1"
# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"
# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"
