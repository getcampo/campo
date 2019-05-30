module ApplicationHelper
  def avatar_tag(user, options = {})
    size = options.fetch :size, '1x'
    image_tag(avatar_url(user), class: "avatar avatar-#{size} rounded")
  end

  def avatar_url(user)
    user.avatar.thumb.url
  end

  def local_time_or_date(time)
    local_relative_time time, type: 'time-or-date'
  end

  def render_paginator(scope)
    render 'shared/paginator', scope: scope
  end
end
