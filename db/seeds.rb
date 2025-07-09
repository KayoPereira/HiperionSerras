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

puts "✅ Seeds concluídos! #{Category.count} categorias criadas."