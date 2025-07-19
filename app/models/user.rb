class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :pets
  has_one_attached :avatar

  # Validações
  validates :first_name, presence: true, length: { minimum: 2, maximum: 50 }
  validates :last_name, presence: true, length: { minimum: 2, maximum: 50 }
  validate :avatar_format

  # Métodos úteis
  def full_name
    "#{first_name} #{last_name}".strip
  end

  def display_name
    full_name.present? ? full_name : email.split('@').first.capitalize
  end

  def avatar_url(size: :medium)
    return "sem-imagem-avatar.png" unless persisted? && avatar.attached?

    begin
      case size
      when :small
        avatar.variant(resize_to_limit: [50, 50])
      when :medium
        avatar.variant(resize_to_limit: [150, 150])
      when :large
        avatar.variant(resize_to_limit: [300, 300])
      else
        avatar.variant(resize_to_limit: [150, 150]) # Default para medium em vez do original
      end
    rescue => e
      Rails.logger.error "Erro ao gerar variant do avatar: #{e.message}"
      "sem-imagem-avatar.png"
    end
  end

  def avatar_path(size: :medium)
    return ActionController::Base.helpers.asset_path("sem-imagem-avatar.png") unless persisted? && avatar.attached?

    begin
      Rails.application.routes.url_helpers.url_for(avatar_url(size))
    rescue => e
      Rails.logger.error "Erro ao gerar path do avatar: #{e.message}"
      ActionController::Base.helpers.asset_path("sem-imagem-avatar.png")
    end
  end

  private

  def avatar_format
    return unless avatar.attached?

    # Só valida se o arquivo foi realmente anexado (não apenas selecionado)
    return unless avatar.blob.present?

    unless avatar.content_type.in?(%w[image/jpeg image/jpg image/png image/gif])
      errors.add(:avatar, 'deve ser uma imagem (JPEG, PNG ou GIF)')
    end

    if avatar.byte_size > 5.megabytes
      errors.add(:avatar, 'deve ter menos de 5MB')
    end
  end
end
