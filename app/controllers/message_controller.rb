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
  end

end
