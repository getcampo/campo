require 'test_helper'

class ForumsControllerTest < ActionDispatch::IntegrationTest
  test "should get forum index" do
    get forums_url
    assert_response :success
  end

  test "should get new pagae" do
    sign_in_as users(:admin)
    get new_forum_url
    assert_response :success
  end

  test "should create forum" do
    sign_in_as users(:admin)
    assert_difference "Forum.count" do
      post forums_url, params: { forum: { name: 'Foo', slug: 'foo', description: 'text' }}
    end
    assert_redirected_to forum_url(Forum.last)
  end

  test "should get edit page" do
    sign_in_as users(:admin)
    forum = Forum.create(name: 'Foo', slug: 'foo', description: 'text')
    get edit_forum_url(forum)
    assert_response :success
  end

  test "should update forum" do
    sign_in_as users(:admin)
    forum = Forum.create(name: 'Foo', slug: 'foo', description: 'text')
    patch forum_url(forum), params: { forum: { name: 'Change' } }
    assert_redirected_to forum_url(forum)
    assert_equal 'Change', forum.reload.name
  end
end
