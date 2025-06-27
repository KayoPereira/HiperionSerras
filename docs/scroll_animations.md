# Animações de Scroll

Este projeto utiliza um sistema de animações de scroll baseado no Stimulus framework para criar efeitos visuais suaves quando os elementos entram na viewport.

## Como Usar

### 1. Adicionar o Controller

Adicione o atributo `data-controller="scroll-animations"` na seção que contém os elementos que você quer animar:

```erb
<section data-controller="scroll-animations">
  <!-- elementos animados aqui -->
</section>
```

### 2. Marcar Elementos para Animação

Para cada elemento que você quer animar, adicione os seguintes atributos:

```erb
<div data-scroll-animations-target="animateElement" 
     data-animation="fadeInUp" 
     data-delay="200">
  Conteúdo do elemento
</div>
```

### Atributos Disponíveis

- `data-scroll-animations-target="animateElement"` - Marca o elemento para ser animado
- `data-animation="tipo"` - Define o tipo de animação (opcional, padrão: fadeInUp)
- `data-delay="ms"` - Define o atraso em milissegundos (opcional, padrão: 0)

### Tipos de Animação Disponíveis

- `fadeInUp` - Aparece de baixo para cima com fade
- `fadeInLeft` - Aparece da esquerda para direita com fade
- `fadeInRight` - Aparece da direita para esquerda com fade
- `fadeIn` - Aparece com fade simples
- `slideInUp` - Desliza de baixo para cima
- `zoomIn` - Aparece com efeito de zoom

### Exemplo Completo

```erb
<section data-controller="scroll-animations">
  <h1 data-scroll-animations-target="animateElement" 
      data-animation="fadeInUp">
    Título Principal
  </h1>
  
  <div data-scroll-animations-target="animateElement" 
       data-animation="fadeInLeft" 
       data-delay="200">
    Conteúdo da esquerda
  </div>
  
  <div data-scroll-animations-target="animateElement" 
       data-animation="fadeInRight" 
       data-delay="400">
    Conteúdo da direita
  </div>
</section>
```

## Acessibilidade

O sistema respeita a preferência `prefers-reduced-motion` do usuário, desabilitando todas as animações para usuários que preferem menos movimento.

## Performance

- Utiliza Intersection Observer API para detectar quando elementos entram na viewport
- Remove observadores após a animação para otimizar performance
- Animações são implementadas com CSS para melhor performance
