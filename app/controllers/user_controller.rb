require_dependency 'password'

class UserController < ApplicationController

	before_filter :validate_params, :on => :create

	# Checks the form is filled correctly
	def validate_params

		@old_params = params
		# Just gets form parameters
		v_params = params.clone
		v_params.delete_if {|k,v| ["action","controller"].include?(k) }
		@validated = false
		if v_params != {}

			# Verification for all filled in
			empty = false
      v_params.each { |k,v| empty = true if v == "" }
			if(empty)
				flash[:notice] = "Please fill in all fields - "
			end

			# Check emails and passwords match
			if(v_params[:pass1] != v_params[:pass2])
				flash[:notice] += "Passwords do not match - "
			end
			if(v_params[:email] != params[:cemail])
				flash[:notice] += "Emails do not match - "
			end
			if(flash[:notice])
				render :action => :create and return
			end
			@validated = true;
		end
	end

  def create
		if @validated
			u = User.new
      u.name 					= params[:name]
      u.handle 				= params[:handle]
      u.email 				= params[:email]
      u.showname 			= params[:showname]
      u.showemail 		= params[:showemail]
      u.notify 				= params[:notify]
			s = Password.salt()
      u.passhash 			= Password.hash(params[:pass1],s)
      u.salt 					= s

			flash[:notice] 	= "User Successfully Created"
			session[:user] = u
			redirect_to :controller => :welcome, :action => :index
		end
  end

  def edit
  end

  def view
		if(session[:user])
			@user = session[:user]
		end
  end

end
