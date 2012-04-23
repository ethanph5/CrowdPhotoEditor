source 'http://rubygems.org'

gem 'rails', '3.1.0'

# Bundle edge Rails instead:
# gem 'rails',     :git => 'git://github.com/rails/rails.git'

# for Heroku deployment - as described in Ap. A of ELLS book

group :development, :test do
  gem 'sqlite3'
  gem 'ruby-debug19', :require => 'ruby-debug'
  gem 'database_cleaner'
  gem 'cucumber-rails'
  gem 'cucumber-rails-training-wheels' # some pre-fabbed step definitions  
  gem 'database_cleaner' # to clear Cucumber's test database between runs
  gem 'capybara'         # lets Cucumber pretend to be a web browser
  gem 'launchy'          # a useful debugging aid for user stories
  gem 'rspec-rails'
  gem 'simplecov', :require => false
  gem "rest-client", "~> 1.6.7"  #newly added to handle uploading photo to imgur
  gem 'devise'
  gem 'omniauth'
  gem 'omniauth-facebook'
  gem 'fb_graph'
  gem 'factory_girl', '2.2.0'
end

group :production do
  gem 'pg'
  gem 'devise'
  gem 'omniauth'
  gem 'omniauth-facebook'
  gem 'fb_graph'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails', "~> 3.1.0"
  gem 'coffee-rails', "~> 3.1.0"
  gem 'uglifier'
  gem 'therubyracer'
  gem 'twitter-bootstrap-rails'
end

gem 'jquery-rails'
gem 'haml'
# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'

#group :test do
  # Pretty printed test output
  #gem 'turn', :require => false
#end
