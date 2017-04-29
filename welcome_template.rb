generate :controller, "welcome index"
route "root to: 'welcome#index'"

File.write("config/routes.rb",File.open("config/routes.rb",&:read).gsub("end","
  get '/:inconu' => 'welcome#inconu'
end
"))


file 'app/views/welcome/index.html.erb', <<-CODE
  <h1>Welcome to #{app_name}!<h1>
CODE

file 'app/controllers/welcome_controller.rb', <<-CODE
class WelcomeController < ApplicationController
  def index
  end

  def inconu
    flash[:error] = "Page #\{params[:inconu]} does not exist"
    redirect_to root_path
  end
end
CODE

if yes?("Do you want commit Welcome page?")
  git :add => "."
  git :commit => "-a -m 'Adding Welcome page'"
end