module ApplicationHelper
  def site_icon_path(site)
    if site.icon.attached?
      url_for site.icon.variant(:normal)
    else
      asset_path "icon.png"
    end
  end

  def site_logo_path(site)
    if site.logo.attached?
      url_for site.logo.variant(:normal)
    else
      asset_path "logo.png"
    end
  end

  def user_avatar_path(user)
    if user.avatar.attached?
      url_for user.avatar.variant(:normal)
    else
      asset_path "avatar.png"
    end
  end

  def local_time_or_date(time)
    local_relative_time time, type: 'time-or-date'
  end

  def render_paginator(scope)
    render 'shared/paginator', scope: scope
  end
end
