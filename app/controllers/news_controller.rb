class NewsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_news, only: [:show, :edit, :update, :destroy]

  # GET /news
  def index
    @news = News.recent.includes(poster_attachment: :blob)
    @published_news = @news.published
    @unpublished_news = @news.unpublished if user_signed_in?
  end

  # GET /news/1
  def show
  end

  # GET /news/new
  def new
    @news = News.new
  end

  # POST /news
  def create
    @news = News.new(news_params)

    if @news.save
      redirect_to @news, notice: 'Notícia criada com sucesso.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # GET /news/1/edit
  def edit
  end

  # PATCH/PUT /news/1
  def update
    if @news.update(news_params)
      redirect_to @news, notice: 'Notícia atualizada com sucesso.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /news/1
  def destroy
    @news.destroy
    redirect_to news_index_path, notice: 'Notícia removida com sucesso.'
  end

  private

  def set_news
    @news = News.find(params[:id])
  end

  def news_params
    params.require(:news).permit(:title, :content, :poster, :published)
  end
end
