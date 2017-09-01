gems_list = [
    "Devise",
    "Cancancan",
    "Bootstrap-sass",
    "Jquery-ui-sass-rails",
    "Bootstrap-social-rails",
    "Bootswatch-rails",
    "Font-awesome-sass",
    "Bh",
    "Jquery-datatables-rails",
    "Bootstrap_form",
    "Paperclip",
    "Prawn",
    "Globalize",
    "Geocoder",
    "Will_paginate",
    "Simple_form",
    "rails_layout",
    "wysiwyg-rails",
    "flot-rails",
    "font-awesome-rails",
    "morrisjs-rails",
    "Capistrano",
    "Whenever"
]

say <<-eos
#{gems_list}
eos

input = ask("Recommend me a name of gem to install?")

case input.downcase.to_s
  when 'devise'
    ############################## Devise ##############################
    if yes?("Would you like to install Devise? [yes/no]")

      # Gems
      gem 'devise'

      # install gems
      run 'bundle install'

      # setup devise
      model = ask("What do you want a user to be called? [user]")
      generate "devise:install"
      environment "config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }", env: 'development'

      model = "user" if model.blank?
      generate "devise #{model.capitalize} username:string first_name:string last_name:string" if yes?("Do you want to Create table #{model.capitalize}? [yes/no]")
      generate "devise:controllers #{model.pluralize}" if yes?("Do you want to create controller for #{model.pluralize}? [yes/no]")
      generate "devise:views #{model.pluralize}" if yes?("Do you want to create views for #{model.pluralize}? [yes/no]")

      if yes?("Do you want to edit routes for #{model.pluralize} ? [yes/no]")
        File.write("config/routes.rb", File.open("config/routes.rb", &:read).gsub("devise_for :#{model.pluralize}", "devise_for :#{model.pluralize},
           controllers: {
               registrations: '#{model.pluralize}/registrations',
               confirmations: '#{model.pluralize}/confirmations',
               sessions: '#{model.pluralize}/sessions',
               passwords: '#{model.pluralize}/passwords'
           },
           path_names: {
               sign_up: 'register',
               sign_in: 'login',
               sign_out: 'logout',
               password: 'secret',
               confirmation: 'verification',
               unlock: 'unblock'
           }"))
      end

      # Migrate db
      rake "db:migrate" if yes?("Do you want to migrate db? [yes/no]")

      # Git
      if yes?("Do you want commit Auth for #{model.pluralize}? [yes/no]")
        git :add => "."
        git :commit => "-a -m 'Adding Authentication for #{model.pluralize}'"
      end

      say <<-eos
  ============================================================================
  Your Devise is now available.
      eos

    end
  ############################## End Devise ##############################
  when 'cancancan'
    ############################## Cancancan ##############################
    if yes?("Would you like to install Cancancan? [yes/no]")

      # Gems
      gem 'cancancan'

      # install gems
      run 'bundle install'

      # stup cancancan
      generate "cancan:ability"

      if yes?("Do you want to Create table for Role? [yes/no]")
        generate "model Role name:string"
        generate "migration addRoleIdToUser role:references"
      end

      # Edit app/models/user.rb
      # File.write("app/models/user.rb",
      #            File.open("app/models/user.rb",
      #                      &:read).gsub("class ApplicationController < ActionController::Base", "class Admin::ApplicationController < ActionController::Base"))

      inject_into_file 'app/models/user.rb', :after => "class User < ApplicationRecord" do
        "\nbelongs_to :role\nbefore_create :set_default_role\n\n\nprivate\ndef set_default_role\nself.role ||= Role.find_by_name('registered')\nend\n"
      end

      inject_into_file 'app/models/role.rb', :after => "class Role < ApplicationRecord" do
        "\nhas_many :users\n"
      end

      append_file 'db/seeds.rb' do
        <<-END
['registered', 'banned', 'moderator', 'admin'].each do |role|
  Role.find_or_create_by({name: role})
end
puts "===> Sample date have been set in DB  Roles!"

User.delete_all
User.create!([
                 {id: -1000, username: "root", email: "imidsac@hotmail.fr", first_name: "SACKO", last_name: "IDRISS", role_id: 1, password: "walilahilhamdou"}
             ])
puts "===> Sample date have been set in DB  Users!"
        END
      end

      # Migrate db and seed
      rake "db:migrate" if yes?("Do you want to migrate db? [yes/no]")
      rake "db:seed" if yes?("Do you want to seed data? [yes/no]")

      # Git
      if yes?("Do you want commit Cancancan? [yes/no]")
        git :add => "."
        git :commit => "-a -m 'Adding Cancancan'"
      end

      say <<-eos
  ============================================================================
  Your Cancancan is now available.
      eos

    end
  ############################## End Cancancan ##############################
  when 'bootstrap-sass'
    ############################## Bootstrap-sass ##############################
    if yes?("Would you like to install Bootstrap-sass? [yes/no]")

      # Gems
      gem 'bootstrap-sass', '~> 3.3.6'
      gem 'jquery-rails' if yes?("Do you want to add jquery-rails gem to Gemfile? [yes/no]")

      # install gems
      run 'bundle install'

      # Setup
      run 'mv app/assets/stylesheets/application.css app/assets/stylesheets/application.scss'
      # Edit app/assets/stylesheets/application.scss
      file 'app/assets/stylesheets/application.scss', <<-END
// "bootstrap-sprockets" must be imported before "bootstrap" and "bootstrap/variables"
@import "bootstrap-sprockets";
@import "bootstrap";
      END

      # Edit app/assets/javascripts/application.js
      append_file 'app/assets/javascripts/application.js' do
        <<-END
//= require jquery
//= require bootstrap-sprockets
        END
      end

      if yes?("Would you like to install Bootstrap-sass for admin area? [yes/no]")
        # Setup
        run 'cp app/assets/stylesheets/application.scss app/assets/stylesheets/admin/application.scss'
        run 'rm app/assets/stylesheets/admin/application.css'
        run 'cp app/assets/javascripts/application.js app/assets/javascripts/admin/application.js'
      end

      # Git
      if yes?("Do you want commit Bootstrap-sass? [yes/no]")
        git :add => "."
        git :commit => "-a -m 'Adding Bootstrap-sass'"
      end

      say <<-eos
  ============================================================================
  Your Bootstrap-sass is now available.
      eos

    end
  ############################## End Bootstrap-sass ##############################
  when 'paperclip'
    ############################## Paperclip ##############################
    if yes?("Would you like to install Paperclip? [yes/no]")

      # Gems
      gem 'paperclip', '~> 5.0.0'

      # install gems
      run 'bundle install'

      # Setup

      # Git
      if yes?("Do you want commit Paperclip? [yes/no]")
        git :add => "."
        git :commit => "-a -m 'Adding Paperclip'"
      end

      say <<-eos
  ============================================================================
  Your Paperclip is now available.
      eos

    end
  ############################## End Paperclip ##############################
  when 'prawn'
    ############################## Prawn ##############################
    if yes?("Would you like to install Prawn? [yes/no]")

      # Gems
      gem 'prawn', '~> 2.1.0'
      gem 'prawn-table', '~> 0.2.2'
      gem 'responders'
      gem 'arabic-letter-connector'

      # install gems
      run 'bundle install'

      # Setup
      unless File.exists?("app/pdfs")
        Dir.mkdir("app/pdfs")
      end

      # Git
      if yes?("Do you want commit Prawn? [yes/no]")
        git :add => "."
        git :commit => "-a -m 'Adding Prawn'"
      end

      say <<-eos
  ============================================================================
  Your Prawn is now available.
      eos

    end
  ############################## End Prawn ##############################
  when 'capistrano'
    ############################## Capistrano ##############################
    if yes?("Would you like to install Capistrano? [yes/no]")

      # Gems
      gem 'capistrano', '~> 3.4.0'
      gem 'capistrano-rails'
      gem 'capistrano-passenger'
      gem 'capistrano-rvm'
      gem 'rvm-capistrano'
      gem 'capistrano-bundler'
      gem 'capistrano-maintenance', require: false

      # install gems
      run 'bundle install'

      # Setup
      run 'cap install'

      # copy production.rb file
      run 'cp config/environments/production.rb config/environments/staging.rb'

      server_name = ask("What do you want a server to be called? [server-app2]")
      server_port = ask("What do you want a server port to be? [2208]")
      server_name = "server-app2" if server_name.blank?
      server_port = 2208 if server_port.blank?

      file "config/deploy.rb", <<-END
# config valid only for current version of Capistrano
lock '3.4.1'

set :repo_url, 'git@github.com:imidsac/#{app_name}.git'
set :stages, %w(production staging)

set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

namespace :deploy do

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end

      END


      file "config/deploy/staging.rb", <<-END
set :application, "#{app_name.upcase}_STAGING"
server '#{server_name}', user: 'imidsac', roles: %w{app db web}, :primary => true, :port => #{server_port}
set :branch, "develop"
set :rails_env, "staging"
set :deploy_to, "/var/www/#{app_name}/staging"
      END

      file "config/deploy/production.rb", <<-END
set :application, "#{app_name.upcase}_PRODUCTION"
server '#{server_name}', user: 'imidsac', roles: %w{app db web}, :primary => true, :port => #{server_port}
set :branch, "master"
set :rails_env, "production"
set :deploy_to, "/var/www/#{app_name}/production"
      END

      # Git
      if yes?("Do you want commit Capistrano? [yes/no]")
        git :add => "."
        git :commit => "-a -m 'Adding Capistrano'"
      end

      say <<-eos
  ============================================================================
  Your Capistrano is now available.
      eos

    end
  ############################## End Capistrano ##############################
  when 'whenever'
    ############################## Whenever ##############################
    if yes?("Would you like to install Whenever? [yes/no]")

      # Gems
      gem 'whenever', :require => false

      # install gems
      run 'bundle install'

      # Setup
      run 'wheneverize .'

      # Edit config/schedule.rb
      append_file 'config/schedule.rb' do
        <<-END
      
eval %Q(module ::Rails
  def self.env
    "\#{@environment}\" || ENV["RAILS_ENV"] || ENV["RACK_ENV"] || "development"
  end
end
)

set :output, "\#{path}/log/cron_log.log\"

case @environment

  when 'development'
    # every 2.month, :at => '0:00 am' do
    #   command "backup perform -t #{app_name}_development_backup"
    # end
    
  when 'staging'
    # every 2.month, :at => '0:00 am' do
    #   command "backup perform -t #{app_name}_staging_backup"
    # end
    
  when 'production'
    # every :reboot do
    #   reboot "backup perform -t #{app_name}_production_backup"
    # end

end
        END
      end

      # Git
      if yes?("Do you want commit Whenever? [yes/no]")
        git :add => "."
        git :commit => "-a -m 'Adding Whenever gem'"
      end

      say <<-eos
  ============================================================================
  Your Whenever is now available.
      eos

    end
  ############################## End Whenever ##############################
  when 'font-awesome-sass'
    ############################## font-awesome-sass ##############################
    if yes?("Would you like to install font-awesome-sass? [yes/no]")

      # Gems
      gem 'font-awesome-sass', '~> 4.7.0'

      # install gems
      run 'bundle install'

      # Setup

      # Edit app/assets/stylesheets/application.scss
      append_file 'app/assets/stylesheets/application.scss' do
        <<-END
      
@import "font-awesome-sprockets";
@import "font-awesome";
        END
      end

      if yes?("Would you like to install font-awesome-sass for admin area? [yes/no]")
        # Edit app/assets/stylesheets/admin/application.scss
        append_file 'app/assets/stylesheets/admin/application.scss' do
          <<-END
      
@import "font-awesome-sprockets";
@import "font-awesome";
          END
        end
      end

      # Git
      if yes?("Do you want commit font-awesome-sass? [yes/no]")
        git :add => "."
        git :commit => "-a -m 'Adding font-awesome-sass gem'"
      end

      say <<-eos
  ============================================================================
  Your font-awesome-sass is now available.
      eos

    end
  ############################## End font-awesome-sass ##############################
  when 'jquery-datatables-rails'
    ############################## jquery-datatables-rails ##############################
    if yes?("Would you like to install jquery-datatables-rails? [yes/no]")

      # Gems
      gem 'jquery-datatables-rails', '~> 3.4.0'

      # install gems
      run 'bundle install'

      # Setup
      # run 'rails generate jquery:datatables:install bootstrap3'

      # inject_into_file 'app/assets/javascripts/application.js', :after => "//= require bootstrap-sprockets" do
      #   "\n//= require dataTables/jquery.dataTables\n//= require dataTables/bootstrap/3/jquery.dataTables.bootstrap\n"
      # end
      #
      # inject_into_file 'app/assets/stylesheets/application.scss', :after => "@import \"bootstrap\";" do
      #   "\n@import \"dataTables/bootstrap/3/jquery.dataTables.bootstrap\";"
      # end

      append_file 'app/assets/javascripts/application.js' do
        <<-EOF
        
//= require dataTables/jquery.dataTables
//= require dataTables/bootstrap/3/jquery.dataTables.bootstrap
        EOF
      end

      append_file 'app/assets/stylesheets/application.scss' do
        <<-EOF
        
@import "dataTables/bootstrap/3/jquery.dataTables.bootstrap";
        EOF
      end

      # app/datatables
      if yes?("Do you want to create app/datatables? [yes/no]")
        unless File.exists?("app/datatables")
          Dir.mkdir("app/datatables")
          Dir.mkdir("app/datatables/ExempleUser")

          file "app/datatables/application_datatable.rb", <<-END
class ApplicationDatatable
  delegate :params, to: :@view
  delegate :link_to, to: :@view

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
      recordsTotal: count,
      recordsFiltered: total_entries,
      data: data
    }
  end


private

  def page
    params[:start].to_i / per_page + 1
  end

  def per_page
    params[:length].to_i > 0 ? params[:length].to_i : 10
  end

  def sort_column
    columns[params[:order]['0'][:column].to_i]
  end

  def sort_direction
    params[:order]['0'][:dir] == "desc" ? "desc" : "asc"
  end
end
          END

          file "app/datatables/ExempleUser/index.html.erb", <<-END
# app/views/users/index.html.erb
<%= content_tag :table, role: :datatable, data: { url: users_path(format: :json)} do %>
  <thead>...</thead>
  <tbody></tbody>
<% end %>
          END

          file "app/datatables/ExempleUser/user_controller.rb", <<-END
# app/controllers/user_controller.rb
  def index
    respond_to do |format|
      format.html
      format.json { render json: UsersDatatable.new(view_context) }
    end
  end
          END

          file "app/datatables/ExempleUser/user_datatable.rb", <<-END
# app/datatables/user_datatable.rb
class UsersDatatable < ApplicationDatatable
  delegate :edit_user_path, to: :@view

  private

  def data
    users.map do |user|
      [].tap do |column|
        column << user.first_name
        column << user.last_name
        column << user.email
        column << user.phone_number

        links = []
        links << link_to('Show', user)
        links << link_to('Edit', edit_user_path(user))
        links << link_to('Destroy', user, method: :delete, data: { confirm: 'Are you sure?' })
        column << links.join(' | ')
      end
    end
  end

  def count
    User.count
  end

  def total_entries
    users.total_count
    # will_paginate
    # users.total_entries
  end

  def users
    @users ||= fetch_users
  end

  def fetch_users
    search_string = []
    columns.each do |term|
      search_string << "\#{term} like :search\"
    end

    # will_paginate
    # users = User.page(page).per_page(per_page)
    users = User.order("\#{sort_column} \#{sort_direction}\")
    users = users.page(page).per(per_page)
    users = users.where(search_string.join(' or '), search: "%\#{params[:search][:value]}%\")
  end

  def columns
    %w(first_name last_name email phone_number)
  end
end
          END

          file "app/datatables/ExempleUser/application.js", <<-END
// app/assets/javascripts/application.js
//= require jquery
//= require datatables

// ...

$(document).on('turbolinks:load', function(){
  $("table[role='datatable']").each(function(){
    $(this).DataTable({
      processing: true,
      serverSide: true,
      ajax: $(this).data('url')
    });
  });  
})
          END

        end
      end


      # Git
      if yes?("Do you want commit jquery-datatables-rails? [yes/no]")
        git :add => "."
        git :commit => "-a -m 'Adding jquery-datatables-rails gem'"
      end

      say <<-eos
  ============================================================================
  Your jquery-datatables-rails is now available.
      eos

    end
  ############################## End jquery-datatables-rails ##############################
  when 'bootstrap_form'
    ############################## bootstrap_form ##############################
    if yes?("Would you like to install rails-bootstrap_form? [yes/no]")

      # Gems
      gem 'bootstrap_form'

      # install gems
      run 'bundle install'

      # Stup
      append_file 'app/assets/stylesheets/application.scss' do
        <<-EOF
        
@import "rails_bootstrap_forms";
        EOF
      end

      # Git
      if yes?("Do you want commit bootstrap_form? [yes/no]")
        git :add => "."
        git :commit => "-a -m 'Adding bootstrap_form gem'"
      end

      say <<-eos
  ============================================================================
  Your bootstrap_form is now available.
      eos

    end
  ############################## End bootstrap_form ##############################
  when 'bootswatch-rails'
    ############################## bootswatch-rails ##############################
    if yes?("Would you like to install rails-bootstrap_form? [yes/no]")

      # Gems
      gem 'bootswatch-rails'

      # install gems
      run 'bundle install'

      # Stup
      append_file 'app/assets/stylesheets/application.scss' do
        <<-EOF
// Example using 'Cerulean' bootswatch

//Import bootstrap-sprockets
@import "bootstrap-sprockets";

// Import cerulean variables
@import "bootswatch/cerulean/variables";

// Then bootstrap itself
@import "bootstrap";

// Bootstrap body padding for fixed navbar
body { padding-top: 60px; }

// And finally bootswatch style itself
@import "bootswatch/cerulean/bootswatch";

// Whatever application styles you have go last
// @import "base";
        EOF
      end

      # Git
      if yes?("Do you want commit bootswatch-rails? [yes/no]")
        git :add => "."
        git :commit => "-a -m 'Adding bootswatch-rails gem'"
      end

      say <<-eos
  ============================================================================
  Your bootswatch-rails is now available.
      eos

    end
  ############################## End bootswatch-rails ##############################
  when 'globalize'
    ############################## globalize ##############################
    if yes?("Would you like to install globalize? [yes/no]")

      # Gems
      # gem 'globalize'

      # install gems
      # run 'bundle install'

      # Stup

      # Git
      # if yes?("Do you want commit globalize? [yes/no]")
      # git :add => "."
      # git :commit => "-a -m 'Adding globalize gem'"
      # end

      say <<-eos
  ============================================================================
  Your globalize is now available.
      eos

    end
  ############################## globalize ##############################
  when 'geocoder'
    ############################## geocoder ##############################
    if yes?("Would you like to install geocoder? [yes/no]")

      # Gems
      # gem 'geocoder'

      # install gems
      # run 'bundle install'

      # Stup

      # Git
      # if yes?("Do you want commit geocoder? [yes/no]")
      # git :add => "."
      # git :commit => "-a -m 'Adding geocoder gem'"
      # end

      say <<-eos
  ============================================================================
  Your geocoder is now available.
      eos

    end
  ############################## geocoder ##############################
  when 'will_paginate'
    ############################## will_paginate ##############################
    if yes?("Would you like to install will_paginate? [yes/no]")

      # Gems
      # gem 'will_paginate'

      # install gems
      # run 'bundle install'

      # Stup

      # Git
      # if yes?("Do you want commit will_paginate? [yes/no]")
      # git :add => "."
      # git :commit => "-a -m 'Adding will_paginate gem'"
      # end

      say <<-eos
  ============================================================================
  Your will_paginate is now available.
      eos

    end
  ############################## will_paginate ##############################
  when 'bh'
    ############################## Bh ##############################
    if yes?("Would you like to install Bh? [yes/no]")

      # Gems
      # gem 'bh'

      # install gems
      # run 'bundle install'

      # Stup

      # Git
      # if yes?("Do you want commit Bh? [yes/no]")
      # git :add => "."
      # git :commit => "-a -m 'Adding Bh gem'"
      # end

      say <<-eos
  ============================================================================
  Your Bh is now available.
      eos

    end
  ############################## Bh ##############################
  when 'simple_form'
    ############################## Simple_form ##############################
    if yes?("Would you like to install Simple_form? [yes/no]")

      # Gems
      # gem 'simple_form'

      # install gems
      # run 'bundle install'

      # Stup
      # generate "rails generate simple_form:install --bootstrap"
      # generate "rails generate simple_form:install --foundation"

      # Git
      # if yes?("Do you want commit Simple_form? [yes/no]")
      #   git :add => "."
      #   git :commit => "-a -m 'Adding Simple_form gem'"
      # end

      say <<-eos
  ============================================================================
  Your Simple_form is now available.
      eos

    end
  ############################## Simple_form ##############################
  when 'rails_layout'
    ############################## rails_layout ##############################
    if yes?("Would you like to install rails_layout? [yes/no]")

      # Gems
      # gem 'rails_layout', :group => [:development]

      # install gems
      # run 'bundle install'

      # Stup
      # generate "layout:install bootstrap4"
      # generate "layout:install bootstrap3"

      # Git
      # if yes?("Do you want commit rails_layout? [yes/no]")
      #   git :add => "."
      #   git :commit => "-a -m 'Adding rails_layout gem'"
      # end

      say <<-eos
  ============================================================================
  Your rails_layout is now available.
      eos

    end
  ############################## rails_layout ##############################
  when 'wysiwyg-rails'
    ############################## wysiwyg-rails ##############################
    if yes?("Would you like to install wysiwyg-rails? [yes/no]")

      # Gems
      gem "wysiwyg-rails"

      # install gems
      run 'bundle install'

      # Stup
      append_file 'app/assets/stylesheets/application.scss' do
        <<-EOF
        
@import "froala_editor.min.css";
@import "froala_style.min.css";
@import "themes/dark.min.css";

@import 'plugins/char_counter.min.css';
@import 'plugins/code_view.min.css';
@import 'plugins/colors.min.css';
@import 'plugins/emoticons.min.css';
@import 'plugins/file.min.css';
@import 'plugins/fullscreen.min.css';
@import 'plugins/help.min.css';
@import 'plugins/image_manager.min.css';
@import 'plugins/image.min.css';
@import 'plugins/line_breaker.min.css';
@import 'plugins/quick_insert.min.css';
@import 'plugins/special_characters.min.css';
@import 'plugins/table.min.css';
@import 'plugins/video.min.css';
        EOF
      end

      append_file 'app/assets/javascripts/application.js' do
        <<-EOF
        
//= require froala_editor.min.js

// Include other plugins.
//= require plugins/align.min.js
//= require plugins/char_counter.min.js
//= require plugins/code_beautifier.min.js
//= require plugins/code_view.min.js
//= require plugins/colors.min.js
//= require plugins/emoticons.min.js
//= require plugins/entities.min.js
//= require plugins/file.min.js
//= require plugins/font_family.min.js
//= require plugins/font_size.min.js
//= require plugins/fullscreen.min.js
//= require plugins/help.min.js
//= require plugins/image.min.js
//= require plugins/image_manager.min.js
//= require plugins/inline_style.min.js
//= require plugins/line_breaker.min.js
//= require plugins/link.min.js
//= require plugins/lists.min.js
//= require plugins/paragraph_format.min.js
//= require plugins/paragraph_style.min.js
//= require plugins/print.min.js
//= require plugins/quick_insert.min.js
//= require plugins/quote.min.js
//= require plugins/save.min.js
//= require plugins/table.min.js
//= require plugins/special_characters.min.js
//= require plugins/url.min.js
//= require plugins/video.min.js
        EOF
      end

      # Git
      if yes?("Do you want commit rails_layout? [yes/no]")
        git :add => "."
        git :commit => "-a -m 'Adding wysiwyg-rails gem'"
      end

      say <<-eos
  ============================================================================
  Your wysiwyg-rails is now available.

  <script>
      $(function() {
          $('.froala-editor').froalaEditor()
      });
  </script>

      eos

    end
  ############################## wysiwyg-rails ##############################
  else
    say <<-eos

#{input} is not name of gem.

    eos

end

