require 'test_helper'

class CertsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get certs_index_url
    assert_response :success
  end

end
