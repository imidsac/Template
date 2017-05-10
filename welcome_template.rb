generate :controller, "welcome index"
route "root to: 'welcome#index'"

if yes?("Do you want route for /:inconnu? (yes/no)")
  File.write("config/routes.rb", File.open("config/routes.rb", &:read).gsub("end", "
  get '/:inconu' => 'welcome#inconu'
end
"))

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

end

file 'app/views/welcome/index.html.erb', <<-CODE
  <h1>Welcome to #{app_name}!<h1>
CODE

if yes?("Do you want commit Welcome page? (yes/no)")
  git :add => "."
  git :commit => "-a -m 'Adding Welcome page'"
end