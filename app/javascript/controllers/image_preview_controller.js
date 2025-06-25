import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="image-preview"
export default class extends Controller {
  static targets = ["input", "preview", "placeholder", "container"]

  connect() {
    this.setupFileValidation()
    this.initializePreview()
  }

  setupFileValidation() {
    if (this.hasInputTarget) {
      this.inputTarget.addEventListener('change', this.handleFileSelect.bind(this))
    }
  }

  initializePreview() {
    // Armazenar a URL original se existir
    const originalSrc = this.element.dataset.imagePreviewOriginalSrc
    if (originalSrc) {
      this.originalSrc = originalSrc
    }

    // Se já existe uma imagem preview (caso de edição), esconder o placeholder
    if (this.hasPreviewTarget && this.previewTarget.src && this.previewTarget.src !== window.location.href) {
      this.showPreview()
    } else {
      this.showPlaceholder()
    }
  }

  handleFileSelect(event) {
    const file = event.target.files[0]
    
    if (!file) {
      this.resetToOriginal()
      return
    }

    // Validar tipo de arquivo
    if (!this.isValidFileType(file)) {
      this.showError('Por favor, selecione uma imagem (JPEG, PNG ou GIF)')
      this.clearInput()
      return
    }

    // Validar tamanho do arquivo (5MB)
    if (file.size > 5 * 1024 * 1024) {
      this.showError('A imagem deve ter menos de 5MB')
      this.clearInput()
      return
    }

    this.showFilePreview(file)
  }

  isValidFileType(file) {
    const validTypes = ['image/jpeg', 'image/jpg', 'image/png', 'image/gif']
    return validTypes.includes(file.type)
  }

  showFilePreview(file) {
    const reader = new FileReader()
    
    reader.onload = (e) => {
      this.updatePreviewImage(e.target.result)
      this.showPreview()
      this.clearErrors()
    }
    
    reader.readAsDataURL(file)
  }

  updatePreviewImage(src) {
    if (this.hasPreviewTarget) {
      this.previewTarget.src = src
    } else {
      // Criar elemento de preview se não existir
      this.createPreviewElement(src)
    }
  }

  createPreviewElement(src) {
    const img = document.createElement('img')
    img.src = src
    img.className = 'img-thumbnail'
    img.style.cssText = 'max-width: 200px; max-height: 200px; object-fit: cover;'
    img.setAttribute('data-image-preview-target', 'preview')
    img.alt = 'Preview da imagem'
    
    if (this.hasContainerTarget) {
      // Inserir antes do placeholder
      if (this.hasPlaceholderTarget) {
        this.containerTarget.insertBefore(img, this.placeholderTarget)
      } else {
        this.containerTarget.appendChild(img)
      }
    }
  }

  showPreview() {
    if (this.hasPreviewTarget) {
      this.previewTarget.style.display = 'block'
      this.previewTarget.classList.remove('d-none')
    }
    
    if (this.hasPlaceholderTarget) {
      this.placeholderTarget.style.display = 'none'
      this.placeholderTarget.classList.add('d-none')
    }
  }

  showPlaceholder() {
    if (this.hasPreviewTarget) {
      this.previewTarget.style.display = 'none'
      this.previewTarget.classList.add('d-none')
    }
    
    if (this.hasPlaceholderTarget) {
      this.placeholderTarget.style.display = 'flex'
      this.placeholderTarget.classList.remove('d-none')
    }
  }

  resetToOriginal() {
    // Se havia uma imagem original (caso de edição), voltar para ela
    if (this.originalSrc && this.hasPreviewTarget) {
      this.previewTarget.src = this.originalSrc
      this.showPreview()
    } else {
      this.showPlaceholder()
    }
    this.clearErrors()
  }

  showError(message) {
    this.clearErrors()
    
    const errorElement = document.createElement('div')
    errorElement.className = 'image-preview-error alert alert-danger mt-2'
    errorElement.textContent = message
    errorElement.setAttribute('data-image-preview-error', 'true')
    
    if (this.hasContainerTarget) {
      this.containerTarget.appendChild(errorElement)
    } else {
      this.element.appendChild(errorElement)
    }
    
    // Remover erro após 5 segundos
    setTimeout(() => {
      this.clearErrors()
    }, 5000)
  }

  clearErrors() {
    const errors = this.element.querySelectorAll('[data-image-preview-error]')
    errors.forEach(error => error.remove())
  }

  clearInput() {
    if (this.hasInputTarget) {
      this.inputTarget.value = ''
    }
  }

  // Método para remover imagem (pode ser chamado por botão)
  removeImage() {
    this.clearInput()
    this.showPlaceholder()
    this.clearErrors()
  }
}
