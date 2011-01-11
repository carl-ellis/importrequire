require 'digest/md5'

module Gravatar

  def Gravatar.getAvatarURL(email)
    return "http://www.gravatar.com/avatar/#{ghash(email)}?s=200&d=retro"
  end

  private

  def Gravatar.ghash(email)
    # remove whitespace and make lowercase
    email.strip!
    email.downcase!
    # hash
    hash = Digest::MD5.hexdigest(email)
    return hash
  end
end
