class Category < ApplicationRecord
  has_many :subcategories, dependent: :destroy
  has_many :products, through: :subcategories
  has_one_attached :photo

  scope :show_in_homepage, -> { where(show_in_homepage: true) }

  validates :title, presence: true, length: { minimum: 2, maximum: 100 }
  validate :photo_format

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
      "sem-imagem-categoria.png"
    end
  end

  private

  def photo_format
    return unless photo.attached?

    return unless photo.blob.present?

    unless photo.blob.content_type.in?(%w[image/jpeg image/png image/gif image/webp])
      errors.add(:photo, 'deve ser uma imagem (JPEG, JPG, PNG, GIF ou WebP)')
    end

    if photo.blob.byte_size > 5.megabytes
      errors.add(:photo, 'deve ter menos de 5MB')
    end
  end
end
