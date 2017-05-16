run 'rvm list'
ruby_version_name = ask("Your Ruby version? [2.4.1]")
ruby_version_name = "2.4.1" if ruby_version_name.blank?
create_file ".ruby-version", "#{ruby_version_name}"

run "rvm #{ruby_version_name} gemset list"

if yes?("Do you want to create new gemset? (yes/no)")
  name = ask("Your new gemset name?")
  run "rvm #{ruby_version_name} gemset create #{name}"
end

run "rvm #{ruby_version_name} gemset list"

# create .ruby-gemset file for rvm
gemset_name = ask("Your Gemset name? [rails5.1]")
gemset_name = "rails5.1" if gemset_name.blank?
create_file ".ruby-gemset", "#{gemset_name}"
# install gems
run 'bundle install'

# copy database.yml file
run 'cp config/database.yml config/database.example'

# Edit database config file
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

# Edit Secrets.yml
File.write("config/secrets.yml", File.open("config/secrets.yml", &:read).gsub("production:
  secret_key_base: <%= ENV[\"SECRET_KEY_BASE\"] %>", "

production:
  secret_key_base: <%= ENV[\"#{app_name.upcase}_PRODUCTION_SECRET_KEY_BASE\"] %>
staging:
  secret_key_base: <%= ENV[\"#{app_name.upcase}_STAGING_SECRET_KEY_BASE\"] %>

"))

# Create db
rake "db:create" if yes?("Do you want to create db? (yes/no)")

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

  unless File.exists?("config/recipes")
    Dir.mkdir("config/recipes")

    file "config/recipes/#{app_name}.sql", <<-END
    END

    file "config/recipes/nginx.conf", <<-END
##
# #{app_name.upcase}
#
server {
    listen 80;
    #server_name  somename  alias  another.alias;
    server_name #{app_name}.com;

    access_log /var/log/nginx/#{app_name}.access.log;
    error_log /var/log/nginx/#{app_name}.error.log;

    root /var/www/#{app_name}/production/current/public;
    index index.html;
    passenger_enabled on;
    passenger_app_env staging;
    client_max_body_size 10M;

    error_page 503 @503;

    # Return a 503 error if the maintenance page exists.
    if (-f /var/www/#{app_name}/shared/public/system/maintenance.html) {
      return 503;
    }

    location @503 {
      # Serve static assets if found.
      if (-f $request_filename) {
        break;
      }

      # Set root to the shared directory.
      root /var/www/#{app_name}/shared/public;
      rewrite ^(.*)$ /system/maintenance.html break;
    }
}
    END

    file "config/recipes/myvars", <<-END
export #{app_name.upcase}_PRODUCTION_SECRET_KEY_BASE=""
export #{app_name.upcase}_STAGING_SECRET_KEY_BASE=""

# SECURITY
export DATABASE_PASSWORD=""
export USERNAME=imidsac
export USER=imidsac
export STAGING_USERNAME=""
export STAGING_PASSWORD=""
    END
  end

  if yes?("Do you want commit? (yes/no)")
    git :add => "."
    git :commit => "-a -m 'initial commit'"
  end

  say <<-eos
  ============================================================================
  Your app is now available.
  eos

end

