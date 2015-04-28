require 'test_helper'

class PossibleNamesControllerTest < ActionController::TestCase
  setup do
    @possible_name = possible_names(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:possible_names)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create possible_name" do
    assert_difference('PossibleName.count') do
      post :create, possible_name: { first_lastname: @possible_name.first_lastname, name: @possible_name.name, second_lastname: @possible_name.second_lastname, user_id: @possible_name.user_id }
    end

    assert_redirected_to possible_name_path(assigns(:possible_name))
  end

  test "should show possible_name" do
    get :show, id: @possible_name
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @possible_name
    assert_response :success
  end

  test "should update possible_name" do
    patch :update, id: @possible_name, possible_name: { first_lastname: @possible_name.first_lastname, name: @possible_name.name, second_lastname: @possible_name.second_lastname, user_id: @possible_name.user_id }
    assert_redirected_to possible_name_path(assigns(:possible_name))
  end

  test "should destroy possible_name" do
    assert_difference('PossibleName.count', -1) do
      delete :destroy, id: @possible_name
    end

    assert_redirected_to possible_names_path
  end
end
