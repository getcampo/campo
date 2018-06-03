module Mentionable
  extend ActiveSupport::Concern

  def mention_users
    mention_users = []
    Nokogiri::HTML(MarkdownRenderer.render(content)).search('//text()').each do |node|
      node.text.scan(/@([a-zA-Z][a-zA-Z0-9\-]+)/).each do |match|
        user = User.find_by username: match.first
        mention_users << user if user
      end
    end
    mention_users.uniq
  end
end
