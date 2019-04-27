module ApplicationHelper
  def avatar_tag(user, options = {})
    size = options.fetch :size, '1x'
    image_tag(url_for(user.avatar.variant(combine_options: { resize: '192x192^', gravity: 'center', extent: '192x192' })), class: "avatar avatar-#{size} rounded")
  end

  def local_time_or_date(time)
    local_relative_time time, type: 'time-or-date'
  end
end
