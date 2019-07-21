class PasswordResetsController < ApplicationController
  before_action :validate_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]
  
  def new
  end

  def create
    if @user = User.find_by(email: params[:password_reset][:email].downcase)
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = "Check your email for password reset instructions"
      redirect_to root_url
    else
      flash[:danger] = "Email address not found!"
      render :new
    end
  end

  def edit
    
  end

  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, "cant be empty")
      render :edit
    elsif @user.update_attributes(user_params)
      log_in @user
      flash[:success] = "Password has been reset!"
      @user.update_column(:reset_digest, nil)
      redirect_to @user
    else
      render :edit
    end
  end

  private 

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def validate_user
    @user = User.find_by(email: params[:email].downcase)
    unless @user && @user.activated? && @user.authenticated?(:reset, params[:id])
      redirect_to root_url
    end
  end

  def check_expiration
    if @user.password_reset_expired?
      flash[:danger] = "Password reset link has expired!"
      redirect_to root_url
    end
  end
end
