class NewUserMailer < ActionMailer::Base
  default :from => "no-reply@importrequire.com"

	def welcome_user(user)
		@user = user
		mail( :to => user['email'],
					:content_type => "text/plain",
					:subject => "Welcome to import::require") 
	end
end
