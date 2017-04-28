# create .rvmrc file for rvm
# create_file ".rvmrc", "rvm gemset use #{app_name}"
gemset_name = ask("Your Gemset name?")
create_file ".rvmrc", "rvm gemset use #{gemset_name}"


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
  if yes?("Do you want commit?")
    git :add => "."
    git :commit => "-a -m 'initial commit'"
  end

  say <<-eos
  ============================================================================
  Your app is now available.
  eos

end

