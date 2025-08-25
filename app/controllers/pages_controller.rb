class PagesController < ApplicationController
  def home
    @categories = Category.show_in_homepage.order(:title)
    @latest_news = News.published.recent.first

    respond_to do |format|
      format.html
      format.any { render :home }
    end
  end

  def construction
    respond_to do |format|
      format.html
      format.any { render :construction }
    end
  end
end
