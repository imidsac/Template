gems_list = [
    "Devise",
    "Cancancan",
    "Bootstrap-sass",
    "font-awesome-sass",
    "jquery-datatables-rails",
    "Paperclip",
    "Prawn",
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
    if yes?("Would you like to install Devise? (yes/no)")

      # Gems
      gem 'devise'

      # install gems
      run 'bundle install'

      # setup devise
      model = ask("What do you want a user to be called? [user]")
      generate "devise:install"
      environment "config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }", env: 'development'

      model = "user" if model.blank?
      generate "devise #{model.capitalize} username:string nom:string prenom:string role:string" if yes?("Do you want to Create table #{model.capitalize}? (yes/no)")
      generate "devise:controllers #{model.pluralize}" if yes?("Do you want to create controller for #{model.pluralize}? (yes/no)")
      generate "devise:views #{model.pluralize}" if yes?("Do you want to create views for #{model.pluralize}? (yes/no)")

      if yes?("Do you want to edit routes for #{model.pluralize} ? (yes/no)")
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

      # Git
      if yes?("Do you want commit Auth for #{model.pluralize}? (yes/no)")
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
    if yes?("Would you like to install Cancancan? (yes/no)")

      # Gems
      gem 'cancancan', '1.10'

      # install gems
      run 'bundle install'

      # stup cancancan
      generate "cancan:ability"

      # Git
      if yes?("Do you want commit Cancancan? (yes/no)")
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
    if yes?("Would you like to install Bootstrap-sass? (yes/no)")

      # Gems
      gem 'bootstrap-sass', '~> 3.3.6'
      gem 'jquery-rails' if yes?("Do you want to add jquery-rails gem to Gemfile? (yes/no)")

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
      file 'app/assets/javascripts/application.js', <<-END
//= require jquery
//= require bootstrap-sprockets
      END

      # Git
      if yes?("Do you want commit Bootstrap-sass? (yes/no)")
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
    if yes?("Would you like to install Paperclip? (yes/no)")

      # Gems
      gem 'paperclip', '~> 5.0.0'

      # install gems
      run 'bundle install'

      # Setup

      # Git
      if yes?("Do you want commit Paperclip? (yes/no)")
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
    if yes?("Would you like to install Prawn? (yes/no)")

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
      if yes?("Do you want commit Prawn? (yes/no)")
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
    if yes?("Would you like to install Capistrano? (yes/no)")

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
      if yes?("Do you want commit Capistrano? (yes/no)")
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
    if yes?("Would you like to install Whenever? (yes/no)")

      # Gems
      gem 'whenever', :require => false

      # install gems
      run 'bundle install'

      # Setup
      run 'wheneverize .'

      # Git
      if yes?("Do you want commit Whenever? (yes/no)")
        git :add => "."
        git :commit => "-a -m 'Adding Whenever'"
      end

      say <<-eos
  ============================================================================
  Your Whenever is now available.
      eos

    end
  ############################## End Whenever ##############################
  when 'font-awesome-sass'
    ############################## font-awesome-sass ##############################
    if yes?("Would you like to install font-awesome-sass? (yes/no)")

      # Gems
      gem 'font-awesome-sass', '~> 4.7.0'

      # install gems
      run 'bundle install'

      # Setup

      # Edit app/assets/stylesheets/application.scss
      file 'app/assets/stylesheets/application.scss', <<-END
@import "font-awesome-sprockets";
@import "font-awesome";
      END

      # Git
      if yes?("Do you want commit font-awesome-sass? (yes/no)")
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
    if yes?("Would you like to install jquery-datatables-rails? (yes/no)")

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
      if yes?("Do you want to create app/datatables? (yes/no)")
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
      if yes?("Do you want commit jquery-datatables-rails? (yes/no)")
        git :add => "."
        git :commit => "-a -m 'Adding jquery-datatables-rails gem'"
      end

      say <<-eos
  ============================================================================
  Your jquery-datatables-rails is now available.
      eos

    end
  ############################## End jquery-datatables-rails ##############################
  else
    say <<-eos

#{input} is not name of gem.

    eos

end

