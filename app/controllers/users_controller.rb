class UsersController < ApplicationController
  before_filter :require_login

  def new
    @user = User.new
	render :layout => 'login'
  end

  def create
    @user = User.new(user_params)
    if @user.save
      cookies[:auth_token] = @user.auth_token
      redirect_to root_url
    else
      render "new"
    end
  end

  def show
   
  end
	
    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation)
    end
	
end
