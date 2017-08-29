run 'rvm list'
ruby_version_name = ask("Your Ruby version? [2.4.1]")
ruby_version_name = "2.4.1" if ruby_version_name.blank?
create_file ".ruby-version", "#{ruby_version_name}"

run "rvm #{ruby_version_name} gemset list"

if yes?("Do you want to create new gemset? [yes/no]")
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
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
  port: 5432
  username: imidsac
  password: <%= ENV["DATABASE_PASSWORD" ] %>
  host: localhost

development:
  <<: *default
  database: #{app_name.downcase}_development

test:
  <<: *default
  database: #{app_name.downcase}_test

staging:
  <<: *default
  database: #{app_name.downcase}_staging

production:
  <<: *default
  database: #{app_name.downcase}_production
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
rake "db:create" if yes?("Do you want to create db? [yes/no]")

# setup git and initial commit
after_bundle do
  git :config => "--global user.email imidsac@hotmail.fr"
  git :config => "--global user.name imidsac"
  git :init

  ############################### GITIGNORE #############################
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

  ############################### RECIPES FOLDER #############################
  unless File.exists?("config/recipes")
    Dir.mkdir("config/recipes")

    file "config/recipes/#{app_name.downcase}.sql", <<-END
    END

    file "config/recipes/nginx-staging.conf", <<-END
##
# #{app_name.upcase}_STAGING
#
server {
    listen 80;
    #server_name  somename  alias  another.alias;
    server_name #{app_name.downcase}.com;

    access_log /var/log/nginx/#{app_name.downcase}_staging.access.log;
    error_log /var/log/nginx/#{app_name.downcase}_staging.error.log;

    root /var/www/#{app_name.upcase}/staging/current/public;
    index index.html;
    passenger_enabled on;
    passenger_app_env staging;
    client_max_body_size 10M;

    error_page 503 @503;

    # Return a 503 error if the maintenance page exists.
    if (-f /var/www/#{app_name.upcase}/staging/shared/public/system/maintenance.html) {
      return 503;
    }

    location @503 {
      # Serve static assets if found.
      if (-f $request_filename) {
        break;
      }

      # Set root to the shared directory.
      root /var/www/#{app_name.upcase}/staging/shared/public;
      rewrite ^(.*)$ /system/maintenance.html break;
    }
}
    END

    file "config/recipes/nginx-production.conf", <<-END
##
# #{app_name.upcase}_PRODUCTION
#
server {
    listen 80;
    #server_name  somename  alias  another.alias;
    server_name #{app_name.downcase}.com;

    access_log /var/log/nginx/#{app_name.downcase}_production.access.log;
    error_log /var/log/nginx/#{app_name.downcase}_production.error.log;

    root /var/www/#{app_name.upcase}/production/current/public;
    index index.html;
    passenger_enabled on;
    passenger_app_env production;
    client_max_body_size 10M;

    error_page 503 @503;

    # Return a 503 error if the maintenance page exists.
    if (-f /var/www/#{app_name.upcase}/production/shared/public/system/maintenance.html) {
      return 503;
    }

    location @503 {
      # Serve static assets if found.
      if (-f $request_filename) {
        break;
      }

      # Set root to the shared directory.
      root /var/www/#{app_name.upcase}/production/shared/public;
      rewrite ^(.*)$ /system/maintenance.html break;
    }
}
    END

    file "config/recipes/myvars", <<-END
export #{app_name.upcase}_PRODUCTION_SECRET_KEY_BASE=""
export #{app_name.upcase}_STAGING_SECRET_KEY_BASE=""

# SECURITY
export DATABASE_PASSWORD="MOImeme"
export USERNAME=imidsac
export USER=imidsac
export STAGING_USERNAME=""
export STAGING_PASSWORD=""
    END
  end

  ############################### ADMIN AREA #############################

  unless File.exists?("app/assets/javascripts/admin")
    Dir.mkdir("app/assets/javascripts/admin")
    Dir.mkdir("app/assets/javascripts/common")
    run 'cp app/assets/javascripts/application.js app/assets/javascripts/admin/application.js'
  end
  unless File.exists?("app/assets/stylesheets/admin")
    Dir.mkdir("app/assets/stylesheets/admin")
    Dir.mkdir("app/assets/stylesheets/common")
    run 'cp app/assets/stylesheets/application.css app/assets/stylesheets/admin/application.css'
  end
  unless File.exists?("app/controllers/admin")
    Dir.mkdir("app/controllers/admin")
    run 'cp app/controllers/application_controller.rb app/controllers/admin/application_controller.rb'

    # Edit application_controller.rb
    File.write("app/controllers/admin/application_controller.rb",
               File.open("app/controllers/admin/application_controller.rb",
                         &:read).gsub("class ApplicationController < ActionController::Base", "class Admin::ApplicationController < ActionController::Base"))

  end
  unless File.exists?("app/views/admin")
    Dir.mkdir("app/views/admin")
    Dir.mkdir("app/views/layouts/admin")
    Dir.mkdir("app/views/common")
    Dir.mkdir("app/views/layouts/partials")
    run 'cp app/views/layouts/application.html.erb app/views/layouts/admin/application.html.erb'
    file "app/views/layouts/partials/_public_header.html.erb", <<-END
    END

    file "app/views/layouts/partials/_admin_header.html.erb", <<-END
    END

    file "app/views/layouts/partials/_msg.html.erb", <<-END
<div class="row">
  <div class="col-xs-10 col-xs-offset-1">
    <% flash.each do |name, msg| %>
        <div class='alert alert-<%="\#{name}"\ %>'>
          <a href="#" class="close" data-dismiss="alert">&#215;</a>
          <%= content_tag :div, msg, :id => "flash_\#{name}"\ if msg.is_a?(String) %>
        </div>
    <% end %>
  </div>
</div>
    END

    file "app/views/layouts/partials/_footer.html.erb", <<-END
    END
  end

  file "lib/tasks/db.rake", <<-END
  
namespace :db do
  DUMP_FMT = 'p' # 'c', 'p', 't', 'd'

  desc 'Dumps the database to backups'
  task sql_dump: :environment do
    dump_sfx = suffix_for_format(DUMP_FMT)
    backup_dir = backup_directory(true)
    cmd = nil
    with_config do |app, host, db, user|
      file_name = Time.now.strftime("%Y%m%d%H%M%S") + "_" + db + '.' + dump_sfx
      cmd = "pg_dump -F \#{DUMP_FMT} -U \#{user} -v --no-owner -h \#{host} -d \#{db} -f \#{backup_dir}/\#{file_name}"
    end
    puts cmd
    exec cmd
  end

  desc 'Dumps a specific table to backups'
  task sql_dump_table: :environment do |_task, args|
    table_name = ENV['table']
    fail ArgumentError unless table_name
    dump_sfx = suffix_for_format(DUMP_FMT)
    backup_dir = backup_directory(true)
    cmd = nil
    with_config do |app, host, db, user|
      file_name = Time.now.strftime("%Y%m%d%H%M%S") + "_" + db + "_\#{table_name.parameterize.underscore}" + '.' + dump_sfx
      cmd = "pg_dump --table \#{table_name} --no-owner -F \#{DUMP_FMT} -U \#{user} -v -h \#{host} -d \#{db} -f \#{backup_dir}/\#{file_name}"
    end
    puts cmd
    exec cmd
  end

  desc 'Show the existing database backups'
  task list_backups: :environment do
    backup_dir = backup_directory
    puts "\#{backup_dir}"
    exec "/bin/ls -lt \#{backup_dir}"
  end

  desc 'Restores the database from a backup using PATTERN'
  task :sql_restore, [:pat] => :environment do |task,args|
    if args.pat.present?
      cmd = nil
      with_config do |app, host, db, user|
        backup_dir = backup_directory
        files = Dir.glob("\#{backup_dir}/*\#{args.pat}*")
        case files.size
          when 0
            puts "No backups found for the pattern '\#{args.pat}'"
          when 1
            file = files.first
            fmt = format_for_file file
            if fmt.nil?
              puts "No recognized dump file suffix: \#{file}"
            else
              cmd = "pg_restore -F \#{fmt} -v -c -C \#{file}"
            end
          else
            puts "Too many files match the pattern '\#{args.pat}':"
            puts ' ' + files.join("\n ")
            puts "Try a more specific pattern"
        end
      end
      unless cmd.nil?
        Rake::Task["db:drop"].invoke
        Rake::Task["db:create"].invoke
        puts cmd
        exec cmd
      end
    else
      puts 'Please pass a pattern to the task'
    end
  end

  private

  def suffix_for_format suffix
    case suffix
      when 'c' then 'dump'
      when 'p' then 'sql'
      when 't' then 'tar'
      when 'd' then 'dir'
      else nil
    end
  end

  def format_for_file file
    case file
      when /\.dump$/ then 'c'
      when /\.sql$/  then 'p'
      when /\.dir$/  then 'd'
      when /\.tar$/  then 't'
      else nil
    end
  end

  def backup_directory(create=false)
    backup_dir = "\#{Rails.root}/db/backups"
    if create and not Dir.exists?(backup_dir)
      puts "Creating \#{backup_dir} .."
      Dir.mkdir(backup_dir)
    end
    backup_dir
  end

  def with_config
    yield Rails.application.class.parent_name.underscore,
        ActiveRecord::Base.connection_config[:host],
        ActiveRecord::Base.connection_config[:database],
        ActiveRecord::Base.connection_config[:username]
  end
end

  END

  file "lib/tasks/initial.rake", <<-END
# encoding: utf-8

namespace :initial do
  desc "Fill database with sample data"
  task init: :environment do

    Rake::Task['db:drop'].invoke
    puts "===> db drop!"
    Rake::Task['db:create'].invoke
    puts "===> db create!"
    Rake::Task['db:migrate'].invoke
    puts "===> db migrate!"

  end

  desc "App vide"
  task vide: :environment do

    Rake::Task['db:drop'].invoke
    puts "===> db drop!"
    Rake::Task['db:create'].invoke
    puts "===> db create!"
    Rake::Task['db:migrate'].invoke
    puts "===> db migrate!"
    Rake::Task['db:seed'].invoke
    puts "===> db data seed!"
    sh "psql -d #{app_name.downcase}_development -f config/recipes/#{app_name.downcase}.sql"
    puts "===> db Function.sql!"
    # Rake::Task['assets:precompile'].invoke
    # puts "===> Assets precompile !"
    # Rake::Task['middleware'].invoke
    # puts "===> Middleware!"

  end

desc "App existe"
  task existe: :environment do

    name = Time.now.strftime "%d%m%Y%H%M%S"

    sh "pg_dump --data-only -d #{app_name.downcase}_development > /tmp/#{app_name.downcase}_development_\#{name}.sql"
    puts "===> DUMP DATABASE !"
    sh "PGPASSWORD=\#{ENV['DATABASE_PASSWORD']} psql -U imidsac -d template1 -c \\"ALTER DATABASE #{app_name.downcase}_development RENAME TO \#{name}_#{app_name.downcase}_development;\\""
    puts "===> ALTER DATABASE !"
    Rake::Task['db:create'].invoke
    puts "===> CREATE DATABASE !"
    Rake::Task['db:migrate'].invoke
    puts "===> MIGRATE DATABASE !"
    sh "PGPASSWORD=\#{ENV['DATABASE_PASSWORD']} psql -U imidsac -d template1 -c \\"ALTER DATABASE #{app_name.downcase}_development SET datestyle TO 'ISO, european';\\""
    puts "===> SET datestyle TO 'ISO, european' !"
    # sh "sudo service postgresql restart"
    # puts "===> RESTART SERVICE POSTGRESQL !"
    sh "PGPASSWORD=\#{ENV['DATABASE_PASSWORD']} psql -d #{app_name.downcase}_development -f /tmp/\#{name}_#{app_name.downcase}_development.sql"
    puts "===> RESTORE DATABASE !"
    sh "psql -d #{app_name.downcase}_development -f config/recipes/#{app_name.downcase}.sql"
    puts "===> db #{app_name.downcase}.sql!"

  end

end
  END

  if yes?("Do you want commit? [yes/no]")
    git :add => "."
    git :commit => "-a -m 'New app'"
  end

  if yes?("Do you want init git flow? [yes/no]")
    git :flow => "init"
  end

  say <<-eos
  ============================================================================
  Your app is now available.
  eos

end

