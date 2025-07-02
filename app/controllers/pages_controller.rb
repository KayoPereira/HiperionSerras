class PagesController < ApplicationController
  def home
    @categories = Category.first(3)
  end

  def construction
  end
end
