class Category < ApplicationRecord
  has_one_attached :photo

  # Validações
  validates :title, presence: true, length: { minimum: 2, maximum: 100 }
  validate :photo_format

  # Método para URL da foto com diferentes tamanhos
  def photo_url(size: :medium)
    if photo.attached?
      case size
      when :small
        photo.variant(resize_to_limit: [100, 100])
      when :medium
        photo.variant(resize_to_limit: [300, 300])
      when :large
        photo.variant(resize_to_limit: [600, 600])
      else
        photo
      end
    else
      # URL para imagem padrão se não houver foto
      "sem-imagem-categoria.png"
    end
  end

  private

  def photo_format
    return unless photo.attached?

    unless photo.content_type.in?(%w[image/jpeg image/jpg image/png image/gif])
      errors.add(:photo, 'deve ser uma imagem (JPEG, PNG ou GIF)')
    end

    if photo.byte_size > 5.megabytes
      errors.add(:photo, 'deve ter menos de 5MB')
    end
  end
end
