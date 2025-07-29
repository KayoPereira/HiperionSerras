class News < ApplicationRecord
  # Rich text field
  has_rich_text :content

  # Anexo de imagem
  has_one_attached :poster

  # Validações
  validates :title, presence: true, length: { minimum: 2, maximum: 200 }
  validates :published, inclusion: { in: [true, false] }
  validate :poster_format

  # Scopes
  scope :published, -> { where(published: true) }
  scope :unpublished, -> { where(published: false) }
  scope :recent, -> { order(published_at: :desc, created_at: :desc) }

  # Callbacks
  before_save :set_published_at

  # Método para URL do poster com diferentes tamanhos
  def poster_url(size: :medium)
    if poster.attached?
      case size
      when :small
        poster.variant(resize_to_limit: [200, 200])
      when :medium
        poster.variant(resize_to_limit: [400, 400])
      when :large
        poster.variant(resize_to_limit: [800, 800])
      else
        poster
      end
    else
      # URL para imagem padrão se não houver poster
      "sem-imagem-news.png"
    end
  end

  # Método para verificar se está publicada
  def published?
    published == true
  end

  # Método para obter data de publicação formatada
  def formatted_published_date
    if published_at.present?
      published_at.strftime("%d/%m/%Y às %H:%M")
    else
      created_at.strftime("%d/%m/%Y às %H:%M")
    end
  end

  private

  def poster_format
    return unless poster.attached?

    # Só valida se o arquivo foi realmente anexado (não apenas selecionado)
    return unless poster.blob.present?

    unless poster.content_type.in?(%w[image/jpeg image/jpg image/png image/gif image/webp])
      errors.add(:poster, 'deve ser uma imagem (JPEG, PNG, GIF ou WebP)')
    end

    if poster.byte_size > 5.megabytes
      errors.add(:poster, 'deve ter menos de 5MB')
    end
  end

  def set_published_at
    if published_changed? && published?
      self.published_at = Time.current if published_at.blank?
    elsif !published?
      self.published_at = nil
    end
  end
end
