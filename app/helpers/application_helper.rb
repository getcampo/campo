module ApplicationHelper
  def avatar_tag(user, options = {})
    size = options.fetch :size, '1x'
    if user.avatar.attached?
      image_tag(url_for(user.avatar.variant(combine_options: { resize: '160x160^', gravity: 'center', extent: '160x160' })), class: "avatar avatar-#{size} rounded")
    else
      content_tag :div, user.name[0], class: "avatar avatar-#{size} letter-avatar rounded"
    end
  end

  def local_time_or_date(time)
    local_relative_time time, type: 'time-or-date'
  end
end
