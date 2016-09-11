class WebPage < ApplicationRecord

  def as_json
    super(:only => [:id, :url], :methods => [:crawled_data_json])
  end

  def crawled_data_json
    return JSON.parse self.crawled_data if !self.crawled_data.blank?
  end

  def parse
    result, state = WebPage.parse_url(self.url)
    self.crawled_data = result.to_json
    self.state = state
    self.save
    return result, state
  end

  def self.parse_url(url, cycle = 0)
    result = {}
    result['h1'] = []
    result['h2'] = []
    result['h3'] = []
    result['a'] = []
    state = -1
    return result, state if cycle > 10
    url = URI.parse(url)
    req = Net::HTTP::Get.new(url.to_s)
    res = Net::HTTP.start(url.host, url.port) {|http|
      http.request(req)
    }
    response_body = res.body
    if res.is_a? Net::HTTPSuccess
      response_body.scan(/<h1(.*)<\/h1/) do |match|
        match[0].scan(/^>(.*)/) do |match1|
          result['h1'] << match1[0]
        end
      end
      response_body.scan(/<h2(.*)<\/h2/) do |match|
        match[0].scan(/^>(.*)/) do |match1|
          result['h2'] << match1[0]
        end
      end
      response_body.scan(/<h3(.*)<\/h3/) do |match|
        match[0].scan(/^>(.*)/) do |match1|
          result['h3'] << match1[0]
        end
      end
      response_body.scan(/<a\s+href=\s*"([^"]+)/) do |match|
        result['a'] << match[0]
      end
      state = 1
    elsif response.is_a? Net::HTTPRedirection
      return self.parse_url(URI.parse(res['location']), cycle + 1)
    end
    return result, state
  end

end
