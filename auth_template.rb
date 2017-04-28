# Gems
gem 'devise'
gem 'cancancan', '1.10'

# install gems
run 'bundle install'

# setup devise
name = ask("What do you want a user to be called?")
generate "devise:install"
generate "devise #{name.capitalize} username:string nom:string prenom:string role:string"
generate "devise:controllers #{name}s"
generate "devise:views #{name}s"
rails_command "db:migrate"

#environment 'config.action_mailer.default_url_options = {host: "http://yourwebsite.example.com"}', env: 'production'
environment "config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }", env: 'development'


File.write("config/routes.rb",File.open("config/routes.rb",&:read).gsub("devise_for :users","devise_for :users,
           controllers: {
               registrations: 'users/registrations',
               confirmations: 'users/confirmations',
               sessions: 'users/sessions',
               passwords: 'users/passwords'
           },
           path_names: {
               sign_up: 'register',
               sign_in: 'login',
               sign_out: 'logout',
               password: 'secret',
               confirmation: 'verification',
               unlock: 'unblock'
           }"))

# stup cancancan
generate "cancan:ability"

if yes?("Do you want commit Auth and Cancan?")
  git :add => "."
  git :commit => "-a -m 'Adding Authentication and Cancancan'"
end