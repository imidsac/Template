# create .rvmrc file for rvm
# create_file ".rvmrc", "rvm gemset use #{app_name}"
create_file ".rvmrc", "rvm gemset use rails5"

### add gems ###

# assets
gem 'bootstrap-sass', '~> 3.3.6'
gem 'bootswatch-rails'
gem 'bh', '~> 1.3.4'
gem 'font-awesome-sass', '~> 4.5.0'

# Paperclip
gem 'paperclip', '~> 5.0.0'

# Deploy
gem 'capistrano', '~> 3.4.0'
gem 'capistrano-rails'
gem 'capistrano-passenger'
gem 'capistrano-rvm'
gem 'rvm-capistrano'
gem 'capistrano-bundler'
gem 'capistrano-maintenance', require: false

# Auth
gem 'devise'

# Droit
gem 'cancancan', '1.10'

# Bootstrap-form
gem 'bootstrap_form', '2.5.2'

# Datatable
gem 'jquery-datatables-rails'
gem 'jquery-ui-rails'

# PDF
gem 'prawn', '~> 2.1.0'
gem 'prawn-table', '~> 0.2.2'
gem 'responders'
gem 'arabic-letter-connector'
# gem 'Arabic-Prawn'
# gem 'pdfkit'

# gem "rails3-generators", :group => [ :development ]
# gem "rspec-rails", :group => [ :development, :test ]
# gem "ffaker", :group => :test
# gem "autotest", :group => :test

# install gems
# run 'bundle install'

# copy database.yml file
run 'cp config/database.yml config/database.example'

# edit database config file
file 'config/database.yml', <<-END
default: &default
  adapter: postgresql
  encoding: unicode
  pool: 5
  port: 5432
  username: imidsac
  password: <%= ENV["DATABASE_PASSWORD" ] %>
  host: localhost

development:
  <<: *default
  database: #{app_name}_development

test:
  <<: *default
  database: #{app_name}_test

staging:
  <<: *default
  database: #{app_name}_staging

production:
  <<: *default
  database: #{app_name}_production
END

rake "db:create"

# generate 'simple_form:install'
# generate 'rspec:install'


# setup devise
# generate "devise:install"
# generate "devise User username:string nom:string prenom:string role:string"
# generate "devise:views"
# rake "db:migrate"

# remove defaults files
# remove_file 'public/index.html'
# remove_file 'rm app/assets/images/rails.png'


# setup git and initial commit
after_bundle do
  git :config => "--global user.email imidsac@hotmail.fr"
  git :config => "--global user.name imidsac"
  git :init

  file '.gitignore', <<-END
*.rbc
capybara-*.html
.rspec
/log
/tmp
/db/*.sqlite3
/db/*.sqlite3-journal
/public/system
/coverage/
/spec/tmp
**.orig
rerun.txt
pickle-email-*.html

# TODO Comment out these rules if you are OK with secrets being uploaded to the repo
config/initializers/secret_token.rb
# config/secrets.yml

# dotenv
# TODO Comment out this rule if environment variables can be committed
.env

## Environment normalization:
/.bundle
/vendor/bundle

# these should all be checked in to normalize the environment:
# Gemfile.lock, .ruby-version, .ruby-gemset

# unless supporting rvm < 1.11.0 or doing something fancy, ignore this:
.rvmrc

# if using bower-rails ignore default bower_components path bower.json files
/vendor/assets/bower_components
*.bowerrc
bower.json

# Ignore pow environment settings
.powenv

# Ignore Byebug command history file.
.byebug_history

/.idea/
  END

  git :add => "."
  git :commit => "-a -m 'initial commit'"

  say <<-eos
  ============================================================================
  Your app is now available.
  eos

end

