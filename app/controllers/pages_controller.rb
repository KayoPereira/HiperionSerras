class PagesController < ApplicationController
  def home
    @categories = Category.first(3)

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
