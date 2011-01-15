class AffiliationController < ApplicationController

  after_filter :endgame

  def endgame
    redirect_to user_name_path(session[:user][:handle] )
  end

  def create
  end

  def delete
  end

end
