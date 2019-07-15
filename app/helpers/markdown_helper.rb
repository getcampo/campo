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

  def markdown_strip(content)
    content
      .yield_self { |content| MarkdownRenderer.render(content) }
      .yield_self { |content| strip_tags(content) }
  end

  def markdown_summary(content, length: 140)
    content
      .yield_self { |content| MarkdownRenderer.render(content) }
      .yield_self { |content| strip_tags(content) }
      .yield_self { |content| truncate(content, length: length) }
  end

  def markdown_postprocess(html)
    doc = Nokogiri::HTML.fragment(html)

    doc.xpath('*//text()').each do |node|
      # skip some element
      unless node.ancestors('a, pre, code').any?
        text = node.encode_special_chars(node.text)

        text.gsub!(/@[a-zA-Z]\w+/) do |match|
          %Q(<a href="/#{match}">#{match}</a>)
        end

        node.replace text
      end
    end

    doc.css('img').each do |node|
      if node['src'] =~ %r(\A/attachments/([^/]+)/)
        token = $1
        if attachment = Attachment.find_by(token: token)
          node['src'] = attachment.file.url
        else
          node['src'] = nil
        end
      end
    end

    doc.css('a').each do |node|
      if node['href'] =~ %r(\A/attachments/([^/]+)/)
        token = $1
        if attachment = Attachment.find_by(token: token)
          node['href'] = attachment.file.url
        else
          node['href'] = nil
        end
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
