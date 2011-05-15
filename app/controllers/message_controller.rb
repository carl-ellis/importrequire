class MessageController < ApplicationController
  def inbox
    if session[:user]
      @user = User.where(:handle => session[:user])[0]
      @messages = @user.messages
    else
      @user = nil
    end
  end

  def view
    message = Message.where(:id => params[:mid])[0]
    if !message.nil?
      if !session[:user].nil?
        u = User.where(:handle => session[:user])[0]
        if message.to_id == u.id
          @message = message
          @to = u.handle
          @from = User.where(:id => message.from_id)[0].handle
          if !@message.read
            @message.read = true
            @message.save
          end
        end
      end
    end

  end

  def compose
    if session[:user]
      @user = User.where(:handle => session[:user])[0]
    else
      @user = nil
    end
  end

  def reply
    message = Message.where(:id => params[:mid])[0]
    if !message.nil?
      if !session[:user].nil?
        user = User.where(:handle => session[:user])[0]
        if message.to_id == user.id
          @user = user
          @old_message = message
          @to = User.where(:id => message.from_id)[0].handle
          @subject = "RE:" + message.subject
          @body = "\r\n \r\n=== Previous message begins here ===\r\n" + message.body
        end
      end
    end
    render :action => "compose"
  end

  def create_mail
    if !session[:user].nil?
      @user = User.where(:handle => session[:user])[0]
      @to = params[:to]
      @subject = params[:subject]
      @body = params[:body]
    
      if @to == "" or @body == "" or @subject == ""
       flash[:notice] = "Remember to fill in all the fields"
       else
         to_user = User.where(:handle => @to)[0]
         if to_user.nil?
           flash[:notice] = "Unrecognised user"
         else
           message = Message.new
           message.to_id = to_user.id
           message.from_id = @user.id
           message.subject = @subject
           message.body = @body

           message.save

           to_user.messages << message
           to_user.save

           #TODO Notify email
            redirect_to :action => "inbox" and return
         end
      end
    end
    render :action => "compose"
  end

  def delete
    message = Message.where(:id => params[:mid])[0]
    if !message.nil?
      if !session[:user].nil?
        u = User.where(:handle => session[:user])[0]
        if message.to_id == u.id
          @user = u
          @message = message
          @message.destroy
        end
      end
    end  
    redirect_to :action => "inbox" 
  end

  def unread
    message = Message.where(:id => params[:mid])[0]
    if !message.nil?
      if !session[:user].nil?
        u = User.where(:handle => session[:user])[0]
        if message.to_id == u.id
          @user = u
          @message = message
          @message.read = false
          @message.save
        end
      end
    end  
    redirect_to :action => "inbox" 
  end
end
