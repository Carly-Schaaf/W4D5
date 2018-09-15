class UsersController < ApplicationController

  def index
    render :index
  end

  def show
    @user = User.find(params[:id])
    render :show
  end

  def new
    user = User.new
    render :new
  end

  def create
    user = User.new(user_params)

    if user.save
      login(user)
      redirect_to users_url
    else
      flash[:errors] = user.errors.full_messages
      redirect_to new_user_url
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :password)
  end
end
