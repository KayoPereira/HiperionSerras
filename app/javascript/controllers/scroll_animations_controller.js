import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="scroll-animations"
export default class extends Controller {
  static targets = ["animateElement"]

  connect() {
    console.log('Scroll animations controller connected')
    console.log('Found elements:', this.animateElementTargets.length)
    this.setupIntersectionObserver()
    this.addInitialClasses()
  }

  disconnect() {
    if (this.observer) {
      this.observer.disconnect()
    }
  }

  setupIntersectionObserver() {
    const options = {
      root: null,
      rootMargin: '0px 0px -100px 0px', // Trigger animation 100px before element enters viewport
      threshold: 0.1
    }

    this.observer = new IntersectionObserver((entries) => {
      entries.forEach(entry => {
        if (entry.isIntersecting) {
          this.animateElement(entry.target)
        }
      })
    }, options)

    // Observe all elements with animation classes
    this.animateElementTargets.forEach(element => {
      this.observer.observe(element)
    })
  }

  addInitialClasses() {
    // Add initial hidden state to all animated elements
    this.animateElementTargets.forEach(element => {
      const animationType = element.dataset.animation || 'fadeInUp'
      element.classList.add('animate-hidden')
      element.dataset.animationType = animationType
      console.log('Added animate-hidden to:', element, 'animation type:', animationType)
    })
  }

  animateElement(element) {
    const animationType = element.dataset.animationType || 'fadeInUp'
    const delay = element.dataset.delay || '0'

    console.log('Animating element:', element, 'with animation:', animationType, 'delay:', delay)

    setTimeout(() => {
      element.classList.remove('animate-hidden')
      element.classList.add('animate-visible', `animate-${animationType}`)
      console.log('Animation applied to:', element)
    }, parseInt(delay))

    // Stop observing this element after animation
    this.observer.unobserve(element)
  }
}
