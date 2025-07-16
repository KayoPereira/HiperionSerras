# Avatar Dropdown - Funcionalidade de Logout

## Descrição
Implementação de um dropdown clicável no avatar da navbar (tanto web quanto mobile) que permite ao usuário fazer logout da aplicação.

## Funcionalidades

### Desktop
- Dropdown aparece ao clicar no avatar
- Mostra informações do usuário (nome e email)
- Opção "Editar Perfil" que redireciona para a página de edição
- Opção "Sair" que faz logout do usuário
- Fecha automaticamente ao clicar fora do dropdown

### Mobile
- Dropdown aparece acima do avatar (para não ficar cortado pela barra inferior)
- Opções simplificadas: "Editar Perfil" e "Sair"
- Mesmo comportamento de fechar ao clicar fora

## Arquivos Modificados

### 1. JavaScript Controller
- `app/javascript/controllers/dropdown_controller.js`
- `app/javascript/controllers/index.js` (registro do controller)

### 2. Estilos CSS
- `app/assets/stylesheets/components/_navbar.scss`

### 3. Template da Navbar
- `app/views/shared/_navbar.html.erb`

## Como Funciona

### Controller Stimulus
O `DropdownController` gerencia:
- Toggle do dropdown (mostrar/esconder)
- Detecção de cliques fora do dropdown
- Função de logout que cria um formulário com método DELETE

### Estilos
- Dropdown posicionado absolutamente
- Seta indicativa no topo
- Responsivo para mobile e desktop
- Hover effects nos itens

### Logout
- Utiliza o método DELETE conforme configuração do Devise
- Inclui token CSRF para segurança
- Redireciona automaticamente após logout

## Uso
1. Usuário clica no avatar
2. Dropdown aparece com opções
3. Usuário pode:
   - Editar perfil (redireciona para `/users/edit`)
   - Fazer logout (submete formulário DELETE para `/users/sign_out`)
4. Dropdown fecha automaticamente ao clicar fora

## Compatibilidade
- Funciona em desktop e mobile
- Compatível com todos os navegadores modernos
- Utiliza Stimulus.js para interatividade
- Integrado com sistema de autenticação Devise
