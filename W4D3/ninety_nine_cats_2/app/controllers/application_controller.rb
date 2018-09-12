class ApplicationController < ActionController::Base
  # protect_from_forgery with: :exception

  def current_user
    @current_user ||= User.find_by(session_token: session[:session_token])
  end

  helper_method :current_user

  def login!(user)
    @current_user = user
    session[:session_token] = user.reset_session_token!
  end

  def logout!
    current_user.reset_session_token!
    session[:session_token] = nil
    @current_user = nil
  end

  def must_own_the_cat
    redirect_to cat_url(params[:id]) unless current_user.cats.exists?(id: params[:id])
  end
end
