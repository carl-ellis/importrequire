require_dependency 'password'

class WelcomeController < ApplicationController

  def index
		if not session[:user].nil?
			redirect_to user_name_path(session[:user].handle)
		end
  end

	def logout
		session[:user] = nil
		render :controller => :welcome, :action => :index
	end

	def login
		if(params[:handle] and params[:pass])
			handle = params[:handle];
			pass = params[:pass];

			#retrieve and compare
			temp = User.where(:handle => handle)
			temp_hash = Password.hash(pass, temp.salt)
			if temp_hash == temp.passhash
				session[:user] = temp
			else
				session[:user] = nil
				flash[:notice] = "Incorrect User/Password"
			end
		else
		session[:user] = nil
		end
		render :action => :index
	end

end
