require 'test_helper'

class AccountExchangesControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get account_exchanges_show_url
    assert_response :success
  end

  test "should get index" do
    get account_exchanges_index_url
    assert_response :success
  end

  test "should get new" do
    get account_exchanges_new_url
    assert_response :success
  end

end
