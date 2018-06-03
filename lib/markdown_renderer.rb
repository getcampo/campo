require 'rouge/plugins/redcarpet'

module MarkdownRenderer
  class Renderer < Redcarpet::Render::HTML
    include Rouge::Plugins::Redcarpet
  end

  def self.render(content)
    renderer = Renderer.new(filter_html: true, safe_links_only: true, hard_wrap: true, link_attributes: { rel: 'nofollow'})
    markdown = Redcarpet::Markdown.new(renderer, autolink: true, fenced_code_blocks: true)
    markdown.render(content)
  end
end
