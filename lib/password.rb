require 'digest/sha2'

module Password

	def Password.salt
		salt = 'a'
    64.times { salt << (i = Kernel.rand(62); i += ((i < 10) ? 48 : ((i < 36) ? 55 : 61 ))).chr }
    salt
	end

	def Password.hash(password,salt)
    Digest::SHA512.hexdigest("#{password}:#{salt}")
  end


end
