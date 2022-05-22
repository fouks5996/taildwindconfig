require 'test_helper'

class SccreensControllerTest < ActionDispatch::IntegrationTest
  setup do
    @sccreen = sccreens(:one)
  end

  test "should get index" do
    get sccreens_url
    assert_response :success
  end

  test "should get new" do
    get new_sccreen_url
    assert_response :success
  end

  test "should create sccreen" do
    assert_difference('Sccreen.count') do
      post sccreens_url, params: { sccreen: {  } }
    end

    assert_redirected_to sccreen_url(Sccreen.last)
  end

  test "should show sccreen" do
    get sccreen_url(@sccreen)
    assert_response :success
  end

  test "should get edit" do
    get edit_sccreen_url(@sccreen)
    assert_response :success
  end

  test "should update sccreen" do
    patch sccreen_url(@sccreen), params: { sccreen: {  } }
    assert_redirected_to sccreen_url(@sccreen)
  end

  test "should destroy sccreen" do
    assert_difference('Sccreen.count', -1) do
      delete sccreen_url(@sccreen)
    end

    assert_redirected_to sccreens_url
  end
end
