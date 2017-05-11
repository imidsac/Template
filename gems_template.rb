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

############################## Bootstrap-sass ##############################
if yes?("Would you like to install Bootstrap-sass? (yes/no)")

  # Gems
  gem 'bootstrap-sass', '~> 3.3.6'

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

############################## Prawn ##############################
if yes?("Would you like to install Whenever? (yes/no)")

  # Gems
  gem 'whenever', :require => false

  # install gems
  # Setup

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
############################## End Prawn ##############################

