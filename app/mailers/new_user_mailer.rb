class NewUserMailer < ActionMailer::Base
  default :from => "no-reply@importrequire.com"

	def welcome_user(user)
		@user = user
		mail( :to => user['email'],
					:subject => "Welcome to import::require")
	end
end
