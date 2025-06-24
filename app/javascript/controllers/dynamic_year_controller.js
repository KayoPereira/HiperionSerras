import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="dynamic-year"
export default class extends Controller {
  static targets = ["year"]

  connect() {
    this.updateYear()
  }

  updateYear() {
    const currentYear = new Date().getFullYear()
    this.yearTarget.textContent = currentYear
  }
}
