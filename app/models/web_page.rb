class WebPageState
  FAILED_TO_PARSE = -1
  REGISTERD = 0
  PARSED = 1
  ALREADY_PARSED = 2
end

class WebPage < ApplicationRecord

  def as_json
    super(:only => [:id, :url], :methods => [:parsed_data])
  end

  def parsed_data
    return WebPageParsedTag.where('web_page_id = ?', self.id)
  end

  def parse
    result, state, response_body = parse_url(self.url)
    save_parsed_results(result, state, response_body) if state != WebPageState::ALREADY_PARSED
    return result, state
  end

  def parse_url(url, cycle = 0)
    result = {}
    state = WebPageState::FAILED_TO_PARSE
    response_body = ''
    return result, state, response_body if cycle > 10
    response = read_content(url)
    if response.is_a? Net::HTTPSuccess
      if response.body.eql?(self.content) and !parsed_data.blank?
        state = WebPageState::ALREADY_PARSED
        return result, state, response_body
      end
      result = parse_response(response)
      state = WebPageState::PARSED
    elsif response.is_a? Net::HTTPRedirection
      return parse_url(URI.parse(res['location']), cycle + 1)
    end
    return result, state, response_body
  end

  def read_content(url)
    url = URI.parse(url)
    req = Net::HTTP::Get.new(url.to_s)
    res = Net::HTTP.start(url.host, url.port) {|http|
      http.request(req)
    }
    return res
  end

  def parse_response(response)
    result = {}
    response_body = response.body
    ['h1','h2','h3'].each{ |h_tag|
      result[h_tag] = parse_tag(response_body, Regexp.new("<#{h_tag}([^<]*)<\/#{h_tag}"))
    }
    result['a'] = parse_tag(response_body, Regexp.new('<a\s+href=\s*"([^">]+)'), false)
    result['a'] += parse_tag(response_body, Regexp.new("<a\s+href=\s*'([^'>]+)"), false)
    return result
  end

  def parse_tag(response_body, regex, second_regex = true)
    result = []
    response_body.scan(regex) do |match|
      if second_regex
        match[0].scan(/^>(.*)/) do |match1|
          result << match1[0]
        end
      else
        result << match[0]
      end
    end
    return result
  end

  def save_parsed_results(result, state, response_body)
    if state == 1
      tags = []
      result.each{ |tag_name, items|
        items.each{ |item|
          tag = WebPageParsedTag.new
          tag.web_page_id = self.id
          tag.tag = tag_name
          tag.content = item
          tags << tag
        }
      }
      WebPageParsedTag.transaction do
        WebPageParsedTag.where('web_page_id = ?', self.id).delete_all
        tags.each{ |tag|
          tag.save
        }
      end
      self.content = response_body
    end
    self.state = state
    self.save
  end

end
