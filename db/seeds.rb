# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

puts "🌱 Iniciando seeds..."

# Limpar categorias existentes
puts "🗑️  Removendo categorias existentes..."
Category.destroy_all

# Dados das categorias com suas respectivas imagens
categories_data = [
  {
    title: "Lâminas de Serra Fita",
    image_file: "serra-fita.png"
  },
  {
    title: "Lâminas de Serra Circular",
    image_file: "serra-circular.png"
  },
  {
    title: "Serviços",
    image_file: "servicos.png"
  }
]

puts "📂 Criando categorias..."

categories_data.each do |category_data|
  puts "  ➕ Criando categoria: #{category_data[:title]}"

  # Criar a categoria
  category = Category.create!(title: category_data[:title])

  # Caminho para a imagem
  image_path = Rails.root.join('app', 'assets', 'images', category_data[:image_file])

  # Verificar se a imagem existe antes de anexar
  if File.exist?(image_path)
    puts "    🖼️  Anexando imagem: #{category_data[:image_file]}"
    category.photo.attach(
      io: File.open(image_path),
      filename: category_data[:image_file],
      content_type: 'image/png'
    )
  else
    puts "    ⚠️  Imagem não encontrada: #{image_path}"
  end
end

# Criar subcategorias de exemplo
puts "📁 Criando subcategorias de exemplo..."

subcategories_data = [
  {
    category_title: "Lâminas de Serra Fita",
    subcategories: [
      "Lâminas 1/2 polegada",
      "Lâminas 3/4 polegada",
      "Lâminas 1 polegada",
      "Lâminas para madeira",
      "Lâminas para metal"
    ]
  },
  {
    category_title: "Lâminas de Serra Circular",
    subcategories: [
      "Lâminas 7 1/4 polegadas",
      "Lâminas 10 polegadas",
      "Lâminas para madeira",
      "Lâminas para metal",
      "Lâminas diamantadas"
    ]
  },
  {
    category_title: "Serviços",
    subcategories: [
      "Afiação de lâminas",
      "Soldagem de lâminas",
      "Manutenção preventiva",
      "Consultoria técnica"
    ]
  }
]

subcategories_data.each do |data|
  category = Category.find_by(title: data[:category_title])
  next unless category

  puts "  📂 Criando subcategorias para: #{category.title}"

  data[:subcategories].each do |subcategory_title|
    puts "    ➕ #{subcategory_title}"
    category.subcategories.create!(title: subcategory_title)
  end
end

# Criar produtos de exemplo
puts "📦 Criando produtos de exemplo..."

products_data = [
  {
    subcategory_title: "Lâminas 1/2 polegada",
    products: [
      {
        title: "Lâmina Serra Fita 1/2\" x 0,025\" x 6 TPI",
        line: "Profissional",
        characteristics: "<p>Lâmina de alta qualidade para cortes precisos em madeira.</p><ul><li>Espessura: 0,025\"</li><li>Largura: 1/2\"</li><li>TPI: 6</li></ul>",
        applications: "<p>Ideal para:</p><ul><li>Cortes curvos em madeira</li><li>Trabalhos de marcenaria</li><li>Projetos artesanais</li></ul>",
        types_of_coatings: "<p>Disponível com:</p><ul><li>Revestimento padrão</li><li>Revestimento anti-corrosão</li></ul>",
        details: "<p>Fabricada com aço carbono de alta qualidade, garantindo durabilidade e precisão nos cortes.</p>"
      },
      {
        title: "Lâmina Serra Fita 1/2\" x 0,032\" x 4 TPI",
        line: "Industrial",
        characteristics: "<p>Lâmina robusta para uso intensivo.</p><ul><li>Espessura: 0,032\"</li><li>Largura: 1/2\"</li><li>TPI: 4</li></ul>",
        applications: "<p>Perfeita para:</p><ul><li>Cortes em madeiras duras</li><li>Uso industrial</li><li>Alta produtividade</li></ul>",
        types_of_coatings: "<p>Revestimentos disponíveis:</p><ul><li>Carbono tratado</li><li>Anti-oxidante</li></ul>",
        details: "<p>Desenvolvida para suportar uso contínuo em ambientes industriais.</p>"
      }
    ]
  },
  {
    subcategory_title: "Lâminas 7 1/4 polegadas",
    products: [
      {
        title: "Disco Serra Circular 7 1/4\" x 24 Dentes",
        line: "Madeira",
        characteristics: "<p>Disco para cortes rápidos e limpos em madeira.</p><ul><li>Diâmetro: 7 1/4\"</li><li>Dentes: 24</li><li>Furo: 5/8\"</li></ul>",
        applications: "<p>Indicado para:</p><ul><li>Cortes longitudinais</li><li>Madeira maciça</li><li>Compensados</li></ul>",
        types_of_coatings: "<p>Opções de revestimento:</p><ul><li>Teflon</li><li>Carbeto de tungstênio</li></ul>",
        details: "<p>Dentes com geometria especial para reduzir o esforço de corte e aumentar a vida útil.</p>"
      }
    ]
  },
  {
    subcategory_title: "Afiação de lâminas",
    products: [
      {
        title: "Serviço de Afiação Profissional",
        line: "Serviços",
        characteristics: "<p>Afiação profissional para todos os tipos de lâminas.</p><ul><li>Equipamentos de precisão</li><li>Técnicos especializados</li><li>Garantia de qualidade</li></ul>",
        applications: "<p>Atendemos:</p><ul><li>Lâminas de serra fita</li><li>Discos de serra circular</li><li>Ferramentas de corte</li></ul>",
        types_of_coatings: "<p>Serviços incluem:</p><ul><li>Limpeza completa</li><li>Afiação de precisão</li><li>Travamento dos dentes</li></ul>",
        details: "<p>Utilizamos tecnologia de ponta para garantir o melhor desempenho das suas ferramentas de corte.</p>"
      }
    ]
  }
]

products_data.each do |data|
  subcategory = Subcategory.find_by(title: data[:subcategory_title])
  next unless subcategory

  puts "  📦 Criando produtos para: #{subcategory.title}"

  data[:products].each do |product_data|
    puts "    ➕ #{product_data[:title]}"
    subcategory.products.create!(
      title: product_data[:title],
      line: product_data[:line],
      characteristics: product_data[:characteristics],
      applications: product_data[:applications],
      types_of_coatings: product_data[:types_of_coatings],
      details: product_data[:details]
    )
  end
end

total_subcategories = Subcategory.count
total_products = Product.count
puts "✅ Seeds concluídos! #{Category.count} categorias, #{total_subcategories} subcategorias e #{total_products} produtos criados."