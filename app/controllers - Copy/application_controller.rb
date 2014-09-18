class ApplicationController < ActionController::Base
  protect_from_forgery
 
  private

  
  def current_user
    @current_user ||= User.find_by_auth_token!(cookies[:auth_token]) if cookies[:auth_token]
  end

  helper_method :current_user

  def authorize
    redirect_to root_path, alert: 'You are Not authorized to view this page.' if current_user.name != 'admin'
  end

  def require_login
    unless logged_in?
	  session[:return_to] = request.fullpath
      flash[:error] = "You must be logged in to access this Application"
      redirect_to login_path # halts request cycle
    end
  end
  
  def logged_in?
	!current_user.nil?
  end
	
	def admin?
		current_user.name == 'admin'
	end
end
