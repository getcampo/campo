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
end
