class ApplicationController < ActionController::Base
  # Removido allow_browser para compatibilidade com dispositivos Apple
  # allow_browser versions: :modern

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_services_category
  before_action :set_news_count

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :avatar])

    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :avatar])
  end

  def after_sign_in_path_for(resource)
    if resource.is_a?(User)
      root_path
    end
  end

  private

  def set_services_category
    @services_category = Rails.cache.fetch("services_category", expires_in: 1.hour) do
      Category.find_by(title: "Serviços")
    end
  end

  def set_news_count
    @news_count = Rails.cache.fetch("news_count", expires_in: 5.minutes) do
      News.count
    end
  end
end
