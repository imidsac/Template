################################### PUBLIC WELCOME ########################################
if yes?("Do you want to create welcome page for public? [yes/no]")

  generate :controller, "welcome home"
  route "root to: 'welcome#home'"

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

  file 'app/views/welcome/home.html.erb', <<-CODE
<h1>Welcome to #{app_name.capitalize}!</h1>
  CODE

    File.write("config/routes.rb", File.open("config/routes.rb", &:read).gsub("end", "
  get '/:inconu' => 'welcome#inconu'
end
"))

end

################################### ADMIN WELCOME ########################################

if yes?("Do you want to create welcome page for admin? [yes/no]")

  generate :controller, "admin/welcome dashboard"

  file 'app/controllers/admin/welcome_controller.rb', <<-CODE
class Admin::WelcomeController < Admin::ApplicationController
  def dashboard
    # if current_user.role == "superAdmin"
    #   @users_count = User.all.count
    #   @posts_count = Post.all.count
    # else
    #   @users_count= nil
    #   @posts_count = current_user.posts.all.count
    # end
  end

end
  CODE

  file 'app/views/admin/welcome/dashboard.html.erb', <<-CODE
<h1>Welcome Admin to #{app_name.capitalize}!</h1>
  CODE

end


if yes?("Do you want commit Welcome page? (yes/no)")
  git :add => "."
  git :commit => "-a -m 'Adding Welcome page'"
end

say <<-eos
  ============================================================================
  Your Welcome page is now available.
eos