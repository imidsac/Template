
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
rake "db:migrate"

# stup cancancan
generate "cancan:ability"

git :add => "."
git :commit => "-a -m 'Adding authentication and cancancan'"