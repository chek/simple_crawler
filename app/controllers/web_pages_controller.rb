class WebPagesController < ApplicationController

  def register
    return render :status => 400 if params[:url].blank?
    web_page = WebPage.where('url = ?', params[:url]).first
    return render :status => 302 if !web_page.blank?
    web_page = WebPage.new
    web_page.url = params[:url]
    web_page.save
    ParsePageJob.perform_later(web_page) if !Rails.env.test?
    return render :status => 201
  end

  def list
    render :json => {:pages => WebPage.all.as_json}
  end

  def parse
    web_page = WebPage.where('id = ?', params[:id]).first if !params[:id].blank?
    return render :status => 404 if web_page.blank?
    ParsePageJob.perform_later(web_page) if !Rails.env.test?
    return render :status => 202
  end

end
