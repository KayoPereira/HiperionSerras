class ProductsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_subcategory
  before_action :set_product, only: [:show, :edit, :update, :destroy, :remove_photo, :remove_detail_image]

  # GET /categories/:category_id/subcategories/:subcategory_id/products
  def index
    @products = @subcategory.products.order(:title)
  end

  # GET /categories/:category_id/subcategories/:subcategory_id/products/1
  def show
  end

  # GET /categories/:category_id/subcategories/:subcategory_id/products/new
  def new
    @product = @subcategory.products.build
  end

  # GET /categories/:category_id/subcategories/:subcategory_id/products/1/edit
  def edit
  end

  # POST /categories/:category_id/subcategories/:subcategory_id/products
  def create
    @product = @subcategory.products.build(product_params)

    if @product.save
      redirect_to [@subcategory.category, @subcategory, @product], notice: 'Produto criado com sucesso.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /categories/:category_id/subcategories/:subcategory_id/products/1
  def update
    # Preservar anexos existentes se novos não foram enviados
    update_params = product_params.dup

    # Se photos não foi enviado ou está vazio, remover do hash de parâmetros
    if update_params[:photos].blank? || (update_params[:photos].is_a?(Array) && update_params[:photos].all?(&:blank?))
      update_params.delete(:photos)
    end

    # Se details_images não foi enviado ou está vazio, remover do hash de parâmetros
    if update_params[:details_images].blank? || (update_params[:details_images].is_a?(Array) && update_params[:details_images].all?(&:blank?))
      update_params.delete(:details_images)
    end

    if @product.update(update_params)
      redirect_to [@subcategory.category, @subcategory, @product], notice: 'Produto atualizado com sucesso.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /categories/:category_id/subcategories/:subcategory_id/products/1
  def destroy
    @product.destroy
    redirect_to category_subcategory_products_url(@subcategory.category, @subcategory),
                notice: 'Produto excluído com sucesso.'
  end

  # DELETE /categories/:category_id/subcategories/:subcategory_id/products/1/remove_photo
  def remove_photo
    photo = @product.photos.find(params[:photo_id])
    photo.purge
    redirect_to edit_category_subcategory_product_path(@subcategory.category, @subcategory, @product),
                notice: 'Foto removida com sucesso.'
  end

  # DELETE /categories/:category_id/subcategories/:subcategory_id/products/1/remove_detail_image
  def remove_detail_image
    image = @product.details_images.find(params[:image_id])
    image.purge
    redirect_to edit_category_subcategory_product_path(@subcategory.category, @subcategory, @product),
                notice: 'Imagem de detalhe removida com sucesso.'
  end

  private

  def set_subcategory
    @subcategory = Subcategory.find(params[:subcategory_id])
    @category = @subcategory.category
  end

  def set_product
    @product = @subcategory.products.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:title, :line, :characteristics, :applications,
                                   :types_of_coatings, :details,
                                   photos: [], details_images: [])
  end
end
