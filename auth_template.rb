# Gems
gem 'devise'
gem 'cancancan', '1.10'

# install gems
run 'bundle install'

# setup devise
model = ask("What do you want a user to be called?")
generate "devise:install"

if yes?("Do you want to create db table for #{model.capitalize} ? (yes/no)")
  generate "devise #{model.capitalize} username:string nom:string prenom:string role:string"
  rails_command "db:migrate"
end

generate "devise:controllers #{model.pluralize}" if yes?("Do you want to create controller for #{model.pluralize} ?")
generate "devise:views #{model.pluralize}" if yes?("Do you want to create views for #{model.pluralize} ?")

#environment 'config.action_mailer.default_url_options = {host: "http://yourwebsite.example.com"}', env: 'production'
environment "config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }", env: 'development'

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

# stup cancancan
generate "cancan:ability"

# Git
if yes?("Do you want commit Auth for #{model.pluralize} and Cancan? (yes/no)")
  git :add => "."
  git :commit => "-a -m 'Adding Authentication for #{model.pluralize} and Cancancan'"
end