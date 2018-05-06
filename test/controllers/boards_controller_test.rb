require 'test_helper'

class BoardsControllerTest < ActionDispatch::IntegrationTest
  test "should get board index" do
    get boards_url
    assert_response :success
  end

  test "should get new pagae" do
    sign_in_as users(:admin)
    get new_board_url
    assert_response :success
  end

  test "should create board" do
    sign_in_as users(:admin)
    assert_difference "Board.count" do
      post boards_url, params: { board: { name: 'Foo', slug: 'foo', description: 'text' }}
    end
    assert_redirected_to board_url(Board.last)
  end

  test "should get edit page" do
    sign_in_as users(:admin)
    board = Board.create(name: 'Foo', slug: 'foo', description: 'text')
    get edit_board_url(board)
    assert_response :success
  end

  test "should update board" do
    sign_in_as users(:admin)
    board = Board.create(name: 'Foo', slug: 'foo', description: 'text')
    patch board_url(board), params: { board: { name: 'Change' } }
    assert_redirected_to board_url(board)
    assert_equal 'Change', board.reload.name
  end
end
