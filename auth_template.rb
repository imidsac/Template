# Gems
gem 'devise'
gem 'cancancan', '1.10'

# install gems
run 'bundle install'

# setup devise
name = ask("What do you want a user to be called?")
generate "devise:install"

if yes?("Do you want to create db table for #{name.capitalize} ?")
  generate "devise #{name.capitalize} username:string nom:string prenom:string role:string"
  rails_command "db:migrate"
end

generate "devise:controllers #{name.pluralize}" if yes?("Do you want to create controller for #{name.pluralize} ?")
generate "devise:views #{name.pluralize}" if yes?("Do you want to create views for #{name.pluralize} ?")

#environment 'config.action_mailer.default_url_options = {host: "http://yourwebsite.example.com"}', env: 'production'
environment "config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }", env: 'development'

if yes?("Do you want to edit routes for #{name.pluralize} ?")
  File.write("config/routes.rb", File.open("config/routes.rb", &:read).gsub("devise_for :#{name.pluralize}", "devise_for :#{name.pluralize},
           controllers: {
               registrations: '#{name.pluralize}/registrations',
               confirmations: '#{name.pluralize}/confirmations',
               sessions: '#{name.pluralize}/sessions',
               passwords: '#{name.pluralize}/passwords'
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

# stup cancancan
generate "cancan:ability"

# Git
if yes?("Do you want commit Auth for #{name.pluralize} and Cancan?")
  git :add => "."
  git :commit => "-a -m 'Adding Authentication for #{name.pluralize} and Cancancan'"
end