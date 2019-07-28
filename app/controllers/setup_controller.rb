class SetupController < ApplicationController
  layout 'session'

  skip_before_action :require_site
  before_action :require_no_site
  before_action :require_sign_in, only: [:update]

  def show
  end

  def update
    Current.user.admin!
    generate_default_data
    redirect_to root_path
  end

  private

  def require_no_site
    if Current.site
      redirect_to root_path
    end
  end

  def generate_default_data
    Site.create(
      title: 'Campo'
    )
    forum = Forum.create(name: I18n.t('default_data.announcement'), slug: 'announcement')
    Topic.create(
      user: Current.user,
      forum: forum,
      title: I18n.t('default_data.topic_title'),
      first_post_attributes: {
        body: I18n.t('default_data.post_body'),
        user: Current.user
      }
    )
  end
end
