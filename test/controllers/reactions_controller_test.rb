require 'test_helper'

class ReactionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = create(:user)
    @post = create(:post)
  end

  test "should like post" do
    sign_in_as @user
    post post_reaction_path(@post, type: 'like'), xhr: true
    assert_response :success
    assert @user.reactions.where(post: @post).like.exists?
  end

  test "should dislike post" do
    sign_in_as @user
    post post_reaction_path(@post, type: 'dislike'), xhr: true
    assert_response :success
    assert @user.reactions.where(post: @post).dislike.exists?
  end

  test "should remove like post" do
    sign_in_as @user
    @user.reactions.create(post: @post, type: 'like')
    delete post_reaction_path(@post, type: 'like'), xhr: true
    assert_response :success
    assert_not @user.reactions.where(post: @post).like.exists?
  end

  test "should remove dislike post" do
    sign_in_as @user
    @user.reactions.create(post: @post, type: 'dislike')
    delete post_reaction_path(@post, type: 'dislike'), xhr: true
    assert_response :success
    assert_not @user.reactions.where(post: @post).dislike.exists?
  end

  test "should like/dislike mutually exclusive" do
    sign_in_as @user
    @user.reactions.create(post: @post, type: 'like')

    post post_reaction_path(@post, type: 'dislike'), xhr: true
    assert_response :success
    assert_not @user.reactions.where(post: @post).like.exists?
    assert @user.reactions.where(post: @post).dislike.exists?

    post post_reaction_path(@post, type: 'like'), xhr: true
    assert_response :success
    assert @user.reactions.where(post: @post).like.exists?
    assert_not @user.reactions.where(post: @post).dislike.exists?
  end
end
