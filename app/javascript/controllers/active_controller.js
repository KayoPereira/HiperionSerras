import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "link" ]

  connect() {
    console.log('JS rodando para active controller')
    this.setActiveBasedOnCurrentPage()
  }

  setActiveBasedOnCurrentPage() {
    // Remove todas as classes active
    const allItems = document.querySelectorAll('.navbar-item')
    allItems.forEach(item => item.classList.remove('active'))

    // Pega a URL atual
    const currentPath = window.location.pathname
    console.log('Current path:', currentPath)

    // Encontra o item correspondente à página atual
    let activeItem = null

    if (currentPath === '/' || currentPath === '/home') {
      // Página inicial
      activeItem = document.querySelector('.navbar-item:nth-child(1)')
    } else if (currentPath.startsWith('/categories')) {
      // Verifica se é uma categoria específica de serviços
      // Pega todos os links da navbar para comparar
      const navbarItems = document.querySelectorAll('.navbar-item')
      let foundMatch = false

      navbarItems.forEach((item, index) => {
        const link = item.querySelector('a')
        if (link && link.href) {
          const linkPath = new URL(link.href).pathname
          if (linkPath === currentPath) {
            activeItem = item
            foundMatch = true
          }
        }
      })

      // Se não encontrou match exato e está em /categories, assume que é produtos
      if (!foundMatch) {
        activeItem = document.querySelector('.navbar-item:nth-child(2)')
      }
    } else if (currentPath.includes('sobre') || currentPath.includes('about')) {
      // Página sobre
      activeItem = document.querySelector('.navbar-item:nth-child(4)')
    } else if (currentPath.includes('user') || currentPath.includes('profile') || currentPath.includes('login')) {
      // Página de perfil/login
      activeItem = document.querySelector('.navbar-item:nth-child(5)')
    }

    // Se não encontrou correspondência, mantém o home ativo
    if (!activeItem) {
      activeItem = document.querySelector('.navbar-item:nth-child(1)')
    }

    if (activeItem) {
      activeItem.classList.add('active')
      console.log('Set active item:', activeItem)
    }
  }

  activate(event) {
    // Encontra o elemento li que contém o link
    const target = event.target.closest('[data-active-target="link"]');

    // Atualiza visualmente o estado ativo imediatamente
    const allItems = document.querySelectorAll('.navbar-item')
    allItems.forEach(item => item.classList.remove('active'))

    if (target) {
      target.classList.add('active');
    }

    // Encontra o link dentro do li e navega para ele
    const link = target ? target.querySelector('a') : null;
    if (link && link.href && link.href !== '#') {
      // Se o clique foi no li mas não no link, simula o clique no link
      if (event.target !== link && !link.contains(event.target)) {
        setTimeout(() => {
          window.location.href = link.href;
        }, 0);
      }
      // Se o clique foi diretamente no link, deixa o comportamento padrão acontecer
    }
  }
}