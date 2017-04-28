generate :controller, "welcome index"
route "root to: 'welcome#index'"
route "get '/:inconu' => 'welcome#inconu'"
file 'app/views/welcome/index.html.erb', <<-CODE
  <h1>Welcome!<h1>
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