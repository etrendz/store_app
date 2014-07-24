class SessionsController < ApplicationController
  def new
	render :layout => 'login'
  end

  def create
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      if params[:remember_me]
        cookies.permanent[:auth_token] = user.auth_token
      else
        cookies[:auth_token] = user.auth_token
      end
	  
	  url = session[:return_to] || root_path
  session[:return_to] = nil
  url = root_path if url.eql?('/logout')
  redirect_to url, :notice => "Logged in!"
  
  
 #     redirect_to root_url, :notice => "Logged in!"
    else
      flash.now.alert = "Invalid email or password"
      render "new"
    end
  end

  def destroy
    cookies.delete(:auth_token)
  session[:return_to] = nil
    redirect_to root_url, :notice => "Logged out!"
  end

end
