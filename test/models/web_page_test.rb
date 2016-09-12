require 'test_helper'

class WebPageTest < ActiveSupport::TestCase

  test "parse test" do
    page = web_pages(:two)
    assert_equal(page.state, WebPageState::REGISTERD)
    result, state = page.parse
    assert_equal(state, 1)
    assert_equal(result.length, 4)
    assert_equal(result['h1'].length, 5)
    assert_equal(result['h2'].length, 13)
    assert_equal(result['h3'].length, 1)
    assert_equal(result['a'].length, 36)
    assert_equal(page.state, WebPageState::PARSED)
  end

end
