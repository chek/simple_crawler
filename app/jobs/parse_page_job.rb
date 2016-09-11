class ParsePageJob < ApplicationJob
  queue_as :default

  def perform(*pages)
    pages.each{ |page|
      page.parse
    }
  end

end
