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

total_subcategories = Subcategory.count
puts "✅ Seeds concluídos! #{Category.count} categorias e #{total_subcategories} subcategorias criadas."