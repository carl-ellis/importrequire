require_dependency 'password'

class WelcomeController < ApplicationController

	before_filter :old_page

	def old_page
		@oc = params[:controller]
		@oa = params[:action]
	end

	# If there is a user session still active, route to profile
  def index
		if session[:user] != nil
			redirect_to user_name_path(session[:user])
		end
  end

	# Logout, clear session stuff
	def logout
		session[:user] = nil
		flash[:notice] = "Logged out successfully"
		render :controller => :welcome, :action => :index
	end

	# Login, check for all parameters, user exists and the password matches
	def login

		# Check fields are filled
		if(params[:handle] != "" and params[:pass] != "")
			handle = params[:handle];
			pass = params[:pass][0];

			#retrieve and compare
			temp = User.where(:handle => handle)
			if temp != []
				temp_hash = Password.hash(pass, temp[0].salt)
				if temp_hash == temp[0].passhash
					session[:user] = temp[0][:handle]
					flash[:notice] = "Logged in successfully"
				else
					session[:user] = nil
					flash[:notice] = "Incorrect User/Password"
				end
			else
				session[:user] = nil
				flash[:notice] = "Incorrect User/Password"
			end
		else
		session[:user] = nil
		end

		if session[:user] != nil
			redirect_to :action => :index
		else
			redirect_to :controller => params[:ocontroller], :action => params[:oaction]
		end
	end

end
