require 'test_helper'

class ClientUsersControllerTest < ActionController::TestCase
  setup do
    @client_user = client_users(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:client_users)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create client_user" do
    assert_difference('ClientUser.count') do
      post :create, client_user: { client_id: @client_user.client_id, user_id: @client_user.user_id }
    end

    assert_redirected_to client_user_path(assigns(:client_user))
  end

  test "should show client_user" do
    get :show, id: @client_user
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @client_user
    assert_response :success
  end

  test "should update client_user" do
    patch :update, id: @client_user, client_user: { client_id: @client_user.client_id, user_id: @client_user.user_id }
    assert_redirected_to client_user_path(assigns(:client_user))
  end

  test "should destroy client_user" do
    assert_difference('ClientUser.count', -1) do
      delete :destroy, id: @client_user
    end

    assert_redirected_to client_users_path
  end
end
