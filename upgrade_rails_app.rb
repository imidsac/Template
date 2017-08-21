
# bundle update rails or bundle update
# rails rails:update
# rails app:update
#
# mkdir app/assets/config
# touch app/assets/config/manifest.js
# mkdir app/assets/javascripts/channels
# touch app/assets/javascripts/channels/.keep
# touch app/assets/javascripts/cable.js
# mkdir -p app/channels/application_cable
# touch app/channels/application_cable/channel.rb
# touch app/channels/application_cable/connection.rb
# mkdir app/jobs
# touch app/jobs/application_job.rb
# mkdir app/mailers
# touch app/mailers/application_mailer.rb
# touch app/views/layouts/mailer.html.erb
# touch app/views/layouts/mailer.text.erb
# touch test/application_system_test_case.rb




class ChangeColumnTypeInUsers < ActiveRecord::Migration
  def up
    rename_column :users, :active, :active_boolean
    add_column :users, :active, :string
    execute "UPDATE users SET active = 'true' WHERE active_boolean = true"
    execute "UPDATE users SET active = 'inactive' WHERE active_boolean = false"
    remove_column :users, :active_boolean
  end
end