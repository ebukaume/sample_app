class StaticPagesController < ApplicationController
  def help
  end

  def home
    redirect_to current_user if logged_in?
  end

  def about
  end

  def contact
  end
end
