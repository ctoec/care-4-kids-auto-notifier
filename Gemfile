source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.3'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0.0'
# Use mariadb (mysql-clone) as the database for Active Record
gem 'mysql2'
# Use Puma as the app server
gem 'puma', '~> 3.11'
gem 'dotenv-rails'
# Use attr_encrypted to provide encryption at rest
gem "attr_encrypted", "~> 3.1.0"
# Use Twilio for sending SMS
gem "twilio-ruby", "~> 5.25"
# Jobs runner gems
gem "daemons", "~> 1.3"
gem "delayed_job_active_record", "~> 4.1.4"
gem 'whenever'


# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'

  # Use Capistrano for deployment
  gem 'capistrano-rails'
  gem 'capistrano-bundler'
  gem "capistrano-rvm"
end

group :test do
  gem 'rspec-rails'
  gem "rspec_junit_formatter"
  gem "timecop", "~> 0.9.1"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
