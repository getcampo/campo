class PostUpdateSearchDataJob < ApplicationJob
  queue_as :default

  def perform(post)
    post.update_search_data
  end
end
