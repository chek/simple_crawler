require 'test_helper'

class WebPagesControllerTest < ActionDispatch::IntegrationTest
  test "should post register" do
    post web_pages_register_url, url: 'http://some_url.com'
    assert_response :success
  end

  test "should post register existing" do
    post web_pages_register_url, url: 'http://some_existing_url.com'
    assert_response(302)
  end

  test "should post register bad request" do
    post web_pages_register_url
    assert_response(400)
  end

  test "should get list" do
    get web_pages_list_url
    assert_response :success
  end

  test "should schedule parse" do
    page = web_pages(:one)
    post '/web_pages/parse/' + page.id.to_s
    assert_response(202)
  end

  test "should schedule parse !existing page" do
    post '/web_pages/parse/2432432'
    assert_response(404)
  end

end
