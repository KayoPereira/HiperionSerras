class SubcategoriesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_category
  before_action :set_subcategory, only: [:show, :edit, :update, :destroy]

  # GET /categories/:category_id/subcategories
  def index
    @subcategories = @category.subcategories.order(:title)
  end

  # GET /categories/:category_id/subcategories/1
  def show
  end

  # GET /categories/:category_id/subcategories/new
  def new
    @subcategory = @category.subcategories.build
  end

  # GET /categories/:category_id/subcategories/1/edit
  def edit
  end

  # POST /categories/:category_id/subcategories
  def create
    @subcategory = @category.subcategories.build(subcategory_params)

    if @subcategory.save
      redirect_to [@category, @subcategory], notice: 'Subcategoria criada com sucesso.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /categories/:category_id/subcategories/1
  def update
    if @subcategory.update(subcategory_params)
      redirect_to [@category, @subcategory], notice: 'Subcategoria atualizada com sucesso.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /categories/:category_id/subcategories/1
  def destroy
    @subcategory.destroy
    redirect_to category_subcategories_url(@category), notice: 'Subcategoria excluída com sucesso.'
  end

  private

  def set_category
    @category = Category.find(params[:category_id])
  end

  def set_subcategory
    @subcategory = @category.subcategories.find(params[:id])
  end

  def subcategory_params
    params.require(:subcategory).permit(:title, :photo)
  end
end
