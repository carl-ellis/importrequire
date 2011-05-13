class NewUserMailer < ActionMailer::Base
  default :from => "no-reply@importrequire.com",
					:charset => "ISO-8859-1"

	def welcome_user(user)
		@user = user
		mail( :to => user['email'],
					:subject => "Welcome to import::require")
	end
end
