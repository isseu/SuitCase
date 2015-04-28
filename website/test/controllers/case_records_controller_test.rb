require 'test_helper'

class CaseRecordsControllerTest < ActionController::TestCase
  setup do
    @case_record = case_records(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:case_records)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create case_record" do
    assert_difference('CaseRecord.count') do
      post :create, case_record: { case_id: @case_record.case_id, user_id: @case_record.user_id }
    end

    assert_redirected_to case_record_path(assigns(:case_record))
  end

  test "should show case_record" do
    get :show, id: @case_record
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @case_record
    assert_response :success
  end

  test "should update case_record" do
    patch :update, id: @case_record, case_record: { case_id: @case_record.case_id, user_id: @case_record.user_id }
    assert_redirected_to case_record_path(assigns(:case_record))
  end

  test "should destroy case_record" do
    assert_difference('CaseRecord.count', -1) do
      delete :destroy, id: @case_record
    end

    assert_redirected_to case_records_path
  end
end
