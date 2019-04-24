require 'rouge/plugins/redcarpet'

module MarkdownHelper
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

  def markdown_render(content)
    content
      .yield_self { |content| MarkdownRenderer.render(content) }
      .yield_self { |content| markdown_postprocess(content) }
      .yield_self { |content| markdown_sanitize(content) }
  end

  def markdown_postprocess(html)
    doc = Nokogiri::HTML.fragment(html)
    doc.xpath('*//text()').each do |node|
      # skip some element
      unless node.ancestors('a, pre, code').any?
      text = node.encode_special_chars(node.text)

      text.gsub!(/@([a-zA-Z][a-zA-Z0-9\-]+)(#(\d+))?/) do |match|
        username = $1
        post_id = $3

        user = User.find_by(username: username)

        if user
          if post_id && post = user.posts.find_by(id: post_id)
            %Q(<a href="#{topic_path(post.topic, number: post.number)}" data-controller="post-mention" data-username="#{username}" data-post-id="#{post_id}">#{match}</a>)
          else
            %Q(<a href="/@#{username}" data-controller="user-mention" data-username="#{username}">#{match}</a>)
          end
        else
          match
        end
      end

      node.replace text
      end
    end
    doc.to_html
  end

  def markdown_sanitize(html)
    sanitize(
      html,
      tags: %w( strong em b i p code pre hr br div span h1 h2 h3 h4 h5 h6 ul ol li a img blockquote ),
      attributes: %w( href src alt title class data-controller data-username data-post-id )
    )
  end
end
