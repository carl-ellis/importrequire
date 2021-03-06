require_dependency 'password'
require_dependency 'search'
require_dependency 'rate'
require 'uri'

class UserController < ApplicationController

	before_filter :validate_params, :only => :create
	before_filter :validate_edit_params, :only => :edit

  def restricted_name(handle)
    return ["inbox", "search", "register", "login", "logout"].include?(handle)
  end

  def validate_edit_params

		@old_params = params
    @validated = false
    if params[:pass]

      user = User.where(:handle => session[:user])[0]
        
      #Means they are editing, first off check password
      pass1 = Password.hash(params[:pass], user[:salt]);
      if pass1 == user[:passhash]
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
    warn = ""
		if v_params != {}

			# Verification for all filled in
			empty = false
      v_params.each { |k,v| empty = true if v == "" }
			if(empty)
				warn += "Please fill in all fields - "
			end

			# Check emails and passwords match
			if(v_params[:pass1] != v_params[:pass2])
				warn += "Passwords do not match - "
			end
			if(v_params[:email] != params[:cemail])
				warn += "Emails do not match - "
			end
      if restricted_name(params[:handle])
        # Made sure it is not the name of a page
				warn += "Handle in use by system - "
      end
			if(warn.size > 0)
        flash[:notice] = warn
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

			suc = verify_recaptcha && u.save
			flash[:notice] 	= suc

			if(suc)
        NewUserMailer.welcome_user(u).deliver if u.notify
				Search.buildUserSearchString(u)
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
			Search.buildUserSearchString(@user)

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
			Search.buildUserSearchString(@user)
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
          if params[:tags] != ""
            tags = []
            params[:tags].split(",").each do |tt|
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

            # Add to work
            tags.each do |t|
              w.tags << t if !w.tags.include?(t)
            end
            w.save
            Search.buildWorkSearchString(w)
          end
					@user.works << w
					@user.save
					Search.buildUserSearchString(@user)
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
        if af.users.size == 0
          af.delete
        end
			Search.buildUserSearchString(@user)
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
          if params[:tags] != ""
            tags = []
            params[:tags].split(",").each do |tt|
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

            # Add to work
            w.tags = []
            tags.each do |t|
              w.tags << t if !w.tags.include?(t)
            end
            w.save
            Search.buildWorkSearchString(w)
          end
          w.save
					@user.save
					Search.buildUserSearchString(@user)
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
        if tt.strip != ""
          # See if already exists, if so, use it
          t = Tag.where(:name => tt)
          if t.length == 0
            t = Tag.new
            t.name = URI.escape(tt)
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
			Search.buildUserSearchString(@user)

    end
    respond_to do |format|
      format.js 
    end  
  end

  def remove_tag
    @user = User.where(:handle => session[:user])[0]
    if params[:id] != ""
      t = Tag.where(:id => params[:id])
      if t.length > 0
        t = t[0]
        @user.tags.delete(t) if @user.tags.include?(t)
      @user.save
			Search.buildUserSearchString(@user)
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
		Search.buildUserSearchString(@user)
    respond_to do |format|
      format.js {render :action => :create_tag} 
    end  
  end

	def rate_work

		work = Work.where(:id => params[:wid])[0]
    @user = User.where(:handle => session[:user])[0]
    @vuser = work.users[0] 
		rating = params[:rating]
		r = Rating.where(:work_id => params[:wid], :user_id => @user.id)

		# See if has a current rating
		if r.length == 0
			r = Rating.new
		else
			r = r[0]
		end
			
		# Get weight
		weight = Rate::calculate_weight(@user, work)

		#r.work_id = work.id
		#r.user_id = @user.id
		r.weight = weight
		r.score = rating

		work.ratings << r
		@user.ratings << r

		work.save
		@user.save
		r.save

		Rate::calculate_rating(work)

    respond_to do |format|
      format.js {render :action => :rate_work} 
    end  
	end
end
