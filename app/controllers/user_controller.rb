require_dependency 'password'

class UserController < ApplicationController

	before_filter :validate_params, :only => :create
	before_filter :validate_edit_params, :only => :edit

  def validate_edit_params

		@old_params = params
    @validated = false
    if params[:pass]
        
      #Means they are editing, first off check password
      pass1 = Password.hash(params[:pass], session[:user][:salt]);
      if pass1 == session[:user][:passhash]
        @validated = true
      else
				flash[:notice] = "Incorrect password"
      end
    end

  end

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

	# Checks the form is filled correctly
	def validate_work_params

		@old_params = params
		# Just gets form parameters
		v_params = params.clone
		v_params.delete_if {|k,v| ["action","controller","handle"].include?(k) }
		@validated = false
		if v_params != {}

			# Verification for all filled in
			empty = false
      v_params.each { |k,v| empty = true if v == "" }
			if(empty)
				flash[:notice] = "Please fill in all fields - "
			else
				@validated = true;
			end
			if(flash[:notice])
				render :edit => :create and return
			end
		end
		return v_params == {}
	end

  def create
		if @validated
			u = User.new
      u.name 					= params[:name]
      u.handle 				= params[:handle]
      u.email 				= params[:email]
      u.showname 			= (params[:showname]) ? true : false;
      u.showemail 		= (params[:showemail]) ? true : false;
      u.notify 				= (params[:notify]) ? true : false;
			s = Password.salt()
      u.passhash 			= Password.hash(params[:pass1],s)
      u.salt 					= s

			suc = u.save
			flash[:notice] 	= suc

			if(suc)
        NewUserMailer.welcome_user(u).deliver
				session[:user] = u[:handle]
				redirect_to :controller => :welcome, :action => :index and return
			else
				@errors = u.errors
				render :action => :create
			end

		end
  end

  def edit
    if session[:user]
      if session[:user] == params[:handle]
        @user = User.where(:handle => session[:user])[0]
        if @validated
          u = @user
          u.name 					= params[:name]
          u.email 				= params[:email]
          u.showname 			= (params[:showname]) ? true : false;
          u.showemail 		= (params[:showemail]) ? true : false;
          u.notify 				= (params[:notify]) ? true : false;
          u.save
          flash[:notice] 	= "Information successfully updated"
        end
      end
    end
  end

  def view
		if(session[:user] && !params[:handle])
			@vuser = User.where(:handle => session[:user])[0]
		end
		if params[:handle]
			vusers = User.where(:handle => params[:handle])[0]
			@vuser = vusers
		end
  end

  def create_affil
    @user = User.where(:handle => session[:user])[0]
    if params[:affiliation] != ""
      # See if already exists, if so, use it
      af = Affiliation.where(:name => params[:affiliation])
      if af.length == 0
        af = Affiliation.new
        af.name = params[:affiliation]
        af.save
      else
        af = af[0]
      end

      # Add to user
      @user.affiliations << af if !@user.affiliations.include?(af)
      @user.save

    end
    respond_to do |format|
      format.js 
    end  
  end

  def remove_affil
    @user = User.where(:handle => session[:user])[0]
    if params[:name] != ""
      af = Affiliation.where(:name => params[:name])
      if af.length > 0
        af = af[0]
        @user.affiliations.delete(af) if @user.affiliations.include?(af)
      @user.save
      end
    end

    respond_to do |format|
      format.js {render :action => :create_affil} 
    end  
  end

  def works
    if session[:user]
      if session[:user] == params[:handle]
        @user = User.where(:handle => session[:user])[0]
				validated = validate_work_params()
        if @validated
          w = Work.new
          w.name 					= params[:name]
          w.description 	= params[:description]
          w.url 					= params[:url]
          w.save
					@user.works << w
					@user.save
          flash[:notice] 	= "Information successfully updated"
        end
      end
    end
  end

  def remove_work
    @user = User.where(:handle => session[:user])[0]
    if params[:wid] != ""
      af = Work.where(:id => params[:wid])
      if af.length > 0
        af = af[0]
        @user.works.delete(af) if @user.works.include?(af)
      @user.save
      end
    end

    respond_to do |format|
      format.js {render :action => :create_work} 
    end  
  end

  def edit_work
    @user = User.where(:handle => session[:user])[0]
    @af = nil
    if params[:wid] != ""
      @af = Work.where(:id => params[:wid])
      if @af.length > 0
        @af = @af[0]
      end
      # Edit if params exist
      if params[:name] and params[:url] and params[:description]
				validated = validate_work_params()
        if @validated
          w = @af
          w.name 					= params[:name]
          w.description 	= params[:description]
          w.url 					= params[:url]
          w.save
					@user.save
          @af = w
          flash[:notice] 	= "Information successfully updated"
        end
      end
    end
  end

  def edit_tags
    @user = User.where(:handle => session[:user])[0]
  end

  def create_tag
    @user = User.where(:handle => session[:user])[0]
    if params[:tag] != ""
      tags = []
      params[:tag].split(",").each do |tt|
        if tt != ""
          # See if already exists, if so, use it
          t = Tag.where(:name => tt)
          if t.length == 0
            t = Tag.new
            t.name = tt
            t.save
          else
            t = t[0]
          end
          tags << t
        end
      end

      # Add to user
      tags.each do |t|
        @user.tags << t if !@user.tags.include?(t)
      end
      @user.save

    end
    respond_to do |format|
      format.js 
    end  
  end

  def remove_tag
    @user = User.where(:handle => session[:user])[0]
    if params[:name] != ""
      t = Tag.where(:name => params[:name])
      if t.length > 0
        t = t[0]
        @user.tags.delete(t) if @user.tags.include?(t)
      @user.save
      end
    end

    respond_to do |format|
      format.js {render :action => :create_tag} 
    end  
  end

  def remove_all_tags
    @user = User.where(:handle => session[:user])[0]
    @user.tags = [] 
    @user.save
    respond_to do |format|
      format.js {render :action => :create_tag} 
    end  
  end
end
