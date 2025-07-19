class Product < ApplicationRecord
  belongs_to :subcategory
  has_one :category, through: :subcategory
  
  # Rich text fields
  has_rich_text :characteristics
  has_rich_text :applications
  has_rich_text :types_of_coatings
  has_rich_text :details
  
  # Anexos de imagens
  has_many_attached :photos
  has_many_attached :details_images

  # Validações
  validates :title, presence: true, length: { minimum: 2, maximum: 200 }
  validates :line, presence: true, length: { minimum: 2, maximum: 100 }
  validate :photos_format
  validate :details_images_format

  # Método para URL da primeira foto com diferentes tamanhos
  def main_photo_url(size: :medium)
    if photos.attached? && photos.first.present?
      case size
      when :small
        photos.first.variant(resize_to_limit: [100, 100])
      when :medium
        photos.first.variant(resize_to_limit: [300, 300])
      when :large
        photos.first.variant(resize_to_limit: [600, 600])
      else
        photos.first
      end
    else
      # URL para imagem padrão se não houver foto
      "sem-imagem-categoria.png"
    end
  end

  # Método para obter categoria através da subcategoria
  def category_title
    subcategory&.category&.title
  end

  private

  def photos_format
    return unless photos.attached?

    photos.each do |photo|
      next unless photo.blob.present?

      unless photo.blob.content_type.in?(%w[image/jpeg image/png image/gif image/webp])
        errors.add(:photos, 'devem ser imagens (JPEG, JPG, PNG, GIF ou WebP)')
        break
      end

      if photo.blob.byte_size > 5.megabytes
        errors.add(:photos, 'devem ter menos de 5MB cada')
        break
      end
    end
  end

  def details_images_format
    return unless details_images.attached?

    details_images.each do |image|
      next unless image.blob.present?

      unless image.blob.content_type.in?(%w[image/jpeg image/png image/gif image/webp])
        errors.add(:details_images, 'devem ser imagens (JPEG, JPG, PNG, GIF ou WebP)')
        break
      end

      if image.blob.byte_size > 5.megabytes
        errors.add(:details_images, 'devem ter menos de 5MB cada')
        break
      end
    end
  end
end
