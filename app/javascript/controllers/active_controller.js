import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "link" ]

  connect() {
    console.log('JS rodando para active controller')
  }

  activate(event) {
    event.preventDefault();
    const target = event.target.closest('[data-active-target="link"]');
    const btnActive = document.querySelector('.active');
  
    btnActive.classList.remove('active');
  
    target.classList.add('active');
  }
}