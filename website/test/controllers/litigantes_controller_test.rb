require 'test_helper'

class LitigantesControllerTest < ActionController::TestCase
  setup do
    @litigante = litigantes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:litigantes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create litigante" do
    assert_difference('Litigante.count') do
      post :create, litigante: { case_id: @litigante.case_id, nombre: @litigante.nombre, participante: @litigante.participante, persona: @litigante.persona, rut: @litigante.rut }
    end

    assert_redirected_to litigante_path(assigns(:litigante))
  end

  test "should show litigante" do
    get :show, id: @litigante
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @litigante
    assert_response :success
  end

  test "should update litigante" do
    patch :update, id: @litigante, litigante: { case_id: @litigante.case_id, nombre: @litigante.nombre, participante: @litigante.participante, persona: @litigante.persona, rut: @litigante.rut }
    assert_redirected_to litigante_path(assigns(:litigante))
  end

  test "should destroy litigante" do
    assert_difference('Litigante.count', -1) do
      delete :destroy, id: @litigante
    end

    assert_redirected_to litigantes_path
  end
end
