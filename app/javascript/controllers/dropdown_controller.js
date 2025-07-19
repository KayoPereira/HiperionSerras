import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="dropdown"
export default class extends Controller {
  static targets = ["menu"]

  connect() {
    // Bind the click outside handler to this instance
    this.clickOutsideHandler = this.clickOutside.bind(this)
  }

  disconnect() {
    // Clean up event listener when controller is disconnected
    document.removeEventListener("click", this.clickOutsideHandler)
  }

  toggle(event) {
    event.preventDefault()
    event.stopPropagation()
    
    const menu = this.menuTarget
    const isVisible = menu.style.display === "block"
    
    if (isVisible) {
      this.hide()
    } else {
      this.show()
    }
  }

  show() {
    this.menuTarget.style.display = "block"
    // Add event listener to detect clicks outside
    setTimeout(() => {
      document.addEventListener("click", this.clickOutsideHandler)
    }, 0)
  }

  hide() {
    this.menuTarget.style.display = "none"
    // Remove event listener
    document.removeEventListener("click", this.clickOutsideHandler)
  }

  clickOutside(event) {
    // Check if the click is outside the dropdown
    if (!this.element.contains(event.target)) {
      this.hide()
    }
  }

  logout(event) {
    event.preventDefault()
    
    // Create a form to submit the logout request with DELETE method
    const form = document.createElement('form')
    form.method = 'POST'
    form.action = '/users/sign_out'
    
    // Add CSRF token
    const csrfToken = document.querySelector('meta[name="csrf-token"]')?.getAttribute('content')
    if (csrfToken) {
      const csrfInput = document.createElement('input')
      csrfInput.type = 'hidden'
      csrfInput.name = 'authenticity_token'
      csrfInput.value = csrfToken
      form.appendChild(csrfInput)
    }
    
    // Add method override for DELETE
    const methodInput = document.createElement('input')
    methodInput.type = 'hidden'
    methodInput.name = '_method'
    methodInput.value = 'delete'
    form.appendChild(methodInput)
    
    // Submit the form
    document.body.appendChild(form)
    form.submit()
  }
}
