class PagesController < ApplicationController
  def home
    @categories = Category.limit(3).order(:title)

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
