import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="avatar-preview"
export default class extends Controller {
  static targets = ["input", "preview", "placeholder"]

  connect() {
    this.setupFileValidation()
  }

  setupFileValidation() {
    if (this.hasInputTarget) {
      this.inputTarget.addEventListener('change', this.handleFileSelect.bind(this))
    }
  }

  handleFileSelect(event) {
    const file = event.target.files[0]
    
    if (!file) {
      this.showPlaceholder()
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

    this.showPreview(file)
  }

  isValidFileType(file) {
    const validTypes = ['image/jpeg', 'image/jpg', 'image/png', 'image/gif']
    return validTypes.includes(file.type)
  }

  showPreview(file) {
    const reader = new FileReader()
    
    reader.onload = (e) => {
      if (this.hasPreviewTarget) {
        this.previewTarget.src = e.target.result
        this.previewTarget.style.display = 'block'
      }
      
      if (this.hasPlaceholderTarget) {
        this.placeholderTarget.style.display = 'none'
      }
    }
    
    reader.readAsDataURL(file)
  }

  showPlaceholder() {
    if (this.hasPreviewTarget) {
      this.previewTarget.style.display = 'none'
    }
    
    if (this.hasPlaceholderTarget) {
      this.placeholderTarget.style.display = 'flex'
    }
  }

  showError(message) {
    // Criar ou atualizar elemento de erro
    let errorElement = this.element.querySelector('.avatar-error')
    
    if (!errorElement) {
      errorElement = document.createElement('div')
      errorElement.className = 'avatar-error alert alert-danger mt-2'
      this.element.appendChild(errorElement)
    }
    
    errorElement.textContent = message
    
    // Remover erro após 5 segundos
    setTimeout(() => {
      if (errorElement.parentNode) {
        errorElement.parentNode.removeChild(errorElement)
      }
    }, 5000)
  }

  clearInput() {
    if (this.hasInputTarget) {
      this.inputTarget.value = ''
    }
    this.showPlaceholder()
  }

  removeAvatar() {
    this.clearInput()
    
    // Se houver um campo hidden para marcar remoção
    const removeField = this.element.querySelector('input[name*="remove_avatar"]')
    if (removeField) {
      removeField.value = '1'
    }
  }
}
