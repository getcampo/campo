class SetupController < ApplicationController
  layout 'session'

  skip_before_action :check_setup_wizard
  before_action :require_setup_wizard_enabled
  before_action :require_sign_in, only: [:update]

  def show
  end

  def update
    Current.user.update(admin: true)
    Current.site.update(setup_wizard_enabled: false)
    generate_default_data
    redirect_to root_path
  end

  private

  def require_setup_wizard_enabled
    unless Current.site.setup_wizard_enabled?
      redirect_to root_path
    end
  end

  def generate_default_data
    forum = Forum.create(name: I18n.t('default_data.announcement'), slug: 'announcement')
    Topic.create!(
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
