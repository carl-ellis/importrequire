require 'digest/md5'

module Gravatar

  DEFAULT_SIZE = 200
  THUMBNAME_SIZE = 80

  def Gravatar.getAvatarURL(email)
    return "http://www.gravatar.com/avatar/#{ghash(email)}?s=#{Gravatar::DEFAULT_SIZE}&d=retro"
  end

  def Gravatar.getThumbAvatarURL(email)
    return "http://www.gravatar.com/avatar/#{ghash(email)}?s=#{Gravatar::THUMBNAME_SIZE}&d=retro"
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
