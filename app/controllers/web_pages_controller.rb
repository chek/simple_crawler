class WebPagesController < ApplicationController

  def register
    if !params[:url].blank?
      web_page = WebPage.where('url = ?', params[:url]).first
      if web_page.blank?
        web_page = WebPage.new
        web_page.url = params[:url]
        web_page.save
        ParsePageJob.perform_later(web_page)
        return render :status => 201
      else
        return render :status => 302
      end
    end
    render :status => 400
  end

  def list
    web_pages = WebPage.all
    render :json => {:pages => web_pages.as_json}
  end

  def parse
    web_page = WebPage.find(params[:id]) if !params[:id].blank?
    web_page = WebPage.where('url = ?', params[:url]).first if !params[:url].blank? and params[:id].blank?
    if !web_page.blank?
      ParsePageJob.perform_later(web_page)
      return render :status => 202
    end
    return render :status => 404
  end

end
