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
