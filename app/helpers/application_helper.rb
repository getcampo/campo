module ApplicationHelper
  def avatar_tag(user, options = {})
    size = options.fetch :size, '1x'
    if user.avatar.attached?
      image_tag(url_for(user.avatar), class: "avatar avatar-#{size}")
    else
      content_tag :div, user.name[0], class: "letter-avatar letter-avatar-#{size}"
    end
  end
end
