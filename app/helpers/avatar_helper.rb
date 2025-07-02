module AvatarHelper
  def user_avatar(user, size: :medium, css_class: "rounded-circle")
    byebug
    if user&.avatar&.attached?
      image_tag user.avatar_url(size: size), 
                alt: "Avatar de #{user.display_name}",
                class: css_class,
                loading: "lazy"
    else
      image_tag "sem-imagem-avatar.png", 
                alt: "Avatar padrão",
                class: css_class,
                loading: "lazy"
    end
  end

  def avatar_upload_field(form, options = {})
    default_options = {
      class: "form-control",
      accept: "image/*",
      data: { 
        preview_target: "avatar-preview",
        max_size: 5.megabytes 
      }
    }
    
    form.file_field :avatar, default_options.merge(options)
  end

  def avatar_preview(user, size: :medium)
    content_tag :div, class: "avatar-preview-container" do
      if user&.avatar&.attached?
        user_avatar(user, size: size, css_class: "avatar-preview rounded-circle")
      else
        content_tag :div, class: "avatar-placeholder rounded-circle d-flex align-items-center justify-content-center" do
          content_tag :i, "", class: "fas fa-user fa-2x text-muted"
        end
      end
    end
  end
end
