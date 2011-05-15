module ApplicationHelper

  def unread_mail(handle)
    id = User.where(:handle => handle)[0].id
    len = Message.where(:to_id => id, :read => false).size
    str = ""
    if len > 0
      str = "(#{len})"
    end
    return str
  end
end
