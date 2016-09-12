require 'test_helper'

class WebPageTest < ActiveSupport::TestCase

  test "parse test" do
    body = "<h1>1</h1><a href='http://www.example.com/>123</a><h2>2</h2><h2>3</h2><a href='http://www.example.com/'>123</a><h3>4</h3><a href='http://www.example.com/'>123</a><h3>5</h3><a href='http://www.example.com/'>123</a><h3>6</h3><a href='http://www.example.com/'>123</a>"
    page = web_pages(:one)
    assert_equal(page.state, WebPageState::REGISTERD)
    stub_request(:any, page.url).
      with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
      to_return(:status => 200, :body => body, :headers => {})
    result, state = page.parse
    assert_equal(state, WebPageState::PARSED)
    assert_equal(result.length, 4)
    assert_equal(result['h1'].length, 1)
    assert_equal(result['h2'].length, 2)
    assert_equal(result['h3'].length, 3)
    assert_equal(result['a'].length, 5)
    assert_equal(page.state, WebPageState::PARSED)
  end

  test "parse test failing" do
    page = web_pages(:one)
    assert_equal(page.state, WebPageState::REGISTERD)
    stub_request(:any, page.url).
        with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
        to_return(:status => 500, :body => "", :headers => {})
    result, state = page.parse
    assert_equal(state, WebPageState::FAILED_TO_PARSE)
    assert_equal(result.length, 0)
    assert_equal(page.state, WebPageState::FAILED_TO_PARSE)
  end

  test "already parsed test" do
    page = web_pages(:two)
    assert_equal(page.state, WebPageState::PARSED)
    stub_request(:any, page.url).
        with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
        to_return(:status => 200, :body => page.content, :headers => {})
    result, state = page.parse
    assert_equal(state, WebPageState::ALREADY_PARSED)
    assert_equal(result.length, 0)
    assert_equal(page.state, WebPageState::PARSED)
  end

end
