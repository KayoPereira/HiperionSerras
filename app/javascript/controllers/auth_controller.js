import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["form", "submitButton", "passwordField", "confirmPasswordField"]

  connect() {
    console.log("Auth controller conectado")
    this.addFormValidation()
    this.addPasswordStrengthIndicator()
  }

  addFormValidation() {
    if (this.hasFormTarget) {
      this.formTarget.addEventListener("submit", (event) => {
        this.handleFormSubmit(event)
      })
    }
  }

  handleFormSubmit(event) {
    if (this.hasSubmitButtonTarget) {
      this.submitButtonTarget.disabled = true
      this.submitButtonTarget.textContent = "Processando..."
      
      // Re-habilita o botão após 3 segundos para evitar travamento
      setTimeout(() => {
        if (this.hasSubmitButtonTarget) {
          this.submitButtonTarget.disabled = false
          this.submitButtonTarget.textContent = this.submitButtonTarget.dataset.originalText || "Entrar"
        }
      }, 3000)
    }
  }

  addPasswordStrengthIndicator() {
    if (this.hasPasswordFieldTarget) {
      this.passwordFieldTarget.addEventListener("input", (event) => {
        this.checkPasswordStrength(event.target.value)
      })
    }
  }

  checkPasswordStrength(password) {
    const strength = this.calculatePasswordStrength(password)
    this.updatePasswordStrengthIndicator(strength)
  }

  calculatePasswordStrength(password) {
    let score = 0
    
    if (password.length >= 8) score += 1
    if (password.match(/[a-z]/)) score += 1
    if (password.match(/[A-Z]/)) score += 1
    if (password.match(/[0-9]/)) score += 1
    if (password.match(/[^a-zA-Z0-9]/)) score += 1
    
    return score
  }

  updatePasswordStrengthIndicator(strength) {
    // Remove indicador existente
    const existingIndicator = this.passwordFieldTarget.parentNode.querySelector('.password-strength')
    if (existingIndicator) {
      existingIndicator.remove()
    }

    // Só mostra indicador se há texto no campo
    if (this.passwordFieldTarget.value.length === 0) return

    // Cria novo indicador
    const indicator = document.createElement('div')
    indicator.className = 'password-strength'
    indicator.style.cssText = `
      margin-top: 8px;
      height: 4px;
      border-radius: 2px;
      transition: all 0.3s ease;
    `

    let color, width, text
    switch (strength) {
      case 0:
      case 1:
        color = '#ff6b6b'
        width = '25%'
        text = 'Muito fraca'
        break
      case 2:
        color = '#ffa726'
        width = '50%'
        text = 'Fraca'
        break
      case 3:
        color = '#ffca28'
        width = '75%'
        text = 'Média'
        break
      case 4:
      case 5:
        color = '#66bb6a'
        width = '100%'
        text = 'Forte'
        break
    }

    indicator.style.background = `linear-gradient(to right, ${color} ${width}, #e1e5e9 ${width})`
    
    const textElement = document.createElement('small')
    textElement.textContent = text
    textElement.style.cssText = `
      color: ${color};
      font-size: 12px;
      font-family: "Work Sans", sans-serif;
      margin-top: 4px;
      display: block;
    `

    this.passwordFieldTarget.parentNode.appendChild(indicator)
    this.passwordFieldTarget.parentNode.appendChild(textElement)
  }

  // Validação de confirmação de senha em tempo real
  validatePasswordConfirmation() {
    if (this.hasPasswordFieldTarget && this.hasConfirmPasswordFieldTarget) {
      const password = this.passwordFieldTarget.value
      const confirmation = this.confirmPasswordFieldTarget.value
      
      if (confirmation.length > 0) {
        if (password === confirmation) {
          this.confirmPasswordFieldTarget.style.borderColor = '#66bb6a'
          this.showPasswordMatchIndicator(true)
        } else {
          this.confirmPasswordFieldTarget.style.borderColor = '#ff6b6b'
          this.showPasswordMatchIndicator(false)
        }
      } else {
        this.confirmPasswordFieldTarget.style.borderColor = '#e1e5e9'
        this.removePasswordMatchIndicator()
      }
    }
  }

  showPasswordMatchIndicator(isMatch) {
    this.removePasswordMatchIndicator()
    
    const indicator = document.createElement('small')
    indicator.className = 'password-match-indicator'
    indicator.style.cssText = `
      font-size: 12px;
      font-family: "Work Sans", sans-serif;
      margin-top: 4px;
      display: block;
    `
    
    if (isMatch) {
      indicator.textContent = '✓ As senhas coincidem'
      indicator.style.color = '#66bb6a'
    } else {
      indicator.textContent = '✗ As senhas não coincidem'
      indicator.style.color = '#ff6b6b'
    }
    
    this.confirmPasswordFieldTarget.parentNode.appendChild(indicator)
  }

  removePasswordMatchIndicator() {
    const existing = this.confirmPasswordFieldTarget?.parentNode?.querySelector('.password-match-indicator')
    if (existing) {
      existing.remove()
    }
  }

  // Event listeners para confirmação de senha
  passwordFieldTargetConnected() {
    if (this.hasConfirmPasswordFieldTarget) {
      this.confirmPasswordFieldTarget.addEventListener("input", () => {
        this.validatePasswordConfirmation()
      })
    }
  }

  confirmPasswordFieldTargetConnected() {
    this.confirmPasswordFieldTarget.addEventListener("input", () => {
      this.validatePasswordConfirmation()
    })
  }

  // Salva o texto original do botão
  submitButtonTargetConnected() {
    if (this.submitButtonTarget.textContent) {
      this.submitButtonTarget.dataset.originalText = this.submitButtonTarget.textContent
    }
  }
}
