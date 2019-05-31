require 'test_helper'

class MarkdownHelperTest < ActionView::TestCase
  test "should link user mentions" do
    user = create(:user)
    assert_equal %Q(<p><a href="/@#{user.username}" data-controller="user-mention" data-username="#{user.username}">@#{user.username}</a></p>), markdown_postprocess("<p>@#{user.username}</p>")
  end

  test "should link post mentions" do
    post = create(:post)
    assert_equal %Q(<p><a href="#{topic_path(post.topic, number: post.number)}" data-controller="post-mention" data-username="#{post.user.username}" data-post-id="#{post.id}">@#{post.user.username}##{post.id}</a></p>), markdown_postprocess("<p>@#{post.user.username}##{post.id}</p>")
  end

  test "should replace attachment image" do
    attachment = create(:attachment)
    markdown = "![filename](/attachments/#{attachment.token}/#{attachment.file_identifier})"
    html = %Q(<p><img src="#{attachment.file.url}" alt="filename"></p>)
    assert_equal html, markdown_render(markdown).strip
  end

  test "should replace attachment link" do
    attachment = create(:attachment)
    markdown = "[filename](/attachments/#{attachment.token}/#{attachment.file_identifier})"
    html = %Q(<p><a href="#{attachment.file.url}">filename</a></p>)
    assert_equal html, markdown_render(markdown).strip
  end
end
