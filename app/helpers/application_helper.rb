module ApplicationHelper
  def local_time_or_date(time)
    local_relative_time time, type: 'time-or-date'
  end

  def render_paginator(scope)
    render 'shared/paginator', scope: scope
  end
end
