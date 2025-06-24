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
    if avatar.attached?
      case size
      when :small
        avatar.variant(resize_to_limit: [50, 50])
      when :medium
        avatar.variant(resize_to_limit: [150, 150])
      when :large
        avatar.variant(resize_to_limit: [300, 300])
      else
        avatar
      end
    else
      # URL para avatar padrão se não houver imagem
      "sem-imagem-avatar.png"
    end
  end

  private

  def avatar_format
    return unless avatar.attached?

    unless avatar.content_type.in?(%w[image/jpeg image/jpg image/png image/gif])
      errors.add(:avatar, 'deve ser uma imagem (JPEG, PNG ou GIF)')
    end

    if avatar.byte_size > 5.megabytes
      errors.add(:avatar, 'deve ter menos de 5MB')
    end
  end
end
