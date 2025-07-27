class ServicesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_service, only: [:show, :edit, :update, :destroy, :remove_photo, :remove_detail_image]

  # GET /services
  def index
    @services = Product.where(is_service: true).order(:title)
  end

  # GET /services/1
  def show
  end

  # GET /services/new
  def new
    @service = Product.new(is_service: true)
  end

  # GET /services/1/edit
  def edit
  end

  # POST /services
  def create
    @service = Product.new(service_params)
    @service.is_service = true
    @service.subcategory = nil

    if @service.save
      redirect_to service_path(@service), notice: 'Serviço criado com sucesso.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /services/1
  def update
    # Preservar anexos existentes se novos não foram enviados
    update_params = service_params.dup

    # Se photos não foi enviado ou está vazio, remover do hash de parâmetros
    if update_params[:photos].blank? || (update_params[:photos].is_a?(Array) && update_params[:photos].all?(&:blank?))
      update_params.delete(:photos)
    end

    # Se details_images não foi enviado ou está vazio, remover do hash de parâmetros
    if update_params[:details_images].blank? || (update_params[:details_images].is_a?(Array) && update_params[:details_images].all?(&:blank?))
      update_params.delete(:details_images)
    end

    # Garantir que continue sendo um serviço
    update_params[:is_service] = true
    update_params[:subcategory_id] = nil

    if @service.update(update_params)
      redirect_to service_path(@service), notice: 'Serviço atualizado com sucesso.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /services/1
  def destroy
    @service.destroy
    redirect_to services_url, notice: 'Serviço excluído com sucesso.'
  end

  # DELETE /services/1/remove_photo
  def remove_photo
    photo = @service.photos.find(params[:photo_id])
    photo.purge
    redirect_to edit_service_path(@service), notice: 'Foto removida com sucesso.'
  end

  # DELETE /services/1/remove_detail_image
  def remove_detail_image
    image = @service.details_images.find(params[:image_id])
    image.purge
    redirect_to edit_service_path(@service), notice: 'Imagem de detalhe removida com sucesso.'
  end

  private

  def set_service
    @service = Product.where(is_service: true).find(params[:id])
  end

  def service_params
    params.require(:product).permit(:title, :line, :characteristics, :applications,
                                   :types_of_coatings, :details,
                                   photos: [], details_images: [])
  end
end
