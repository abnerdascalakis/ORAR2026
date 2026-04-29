# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

[ "Masculino", "Feminino" ].each do |nome|
  Sexo.find_or_create_by!(nome: nome)
end

[
  "Agenor de Carvalho",
  "Apuí",
  "Areal",
  "Candeias",
  "Central PVH",
  "Conjunto Buritis",
  "Costa e Silva",
  "Eldorado",
  "Floresta",
  "Guajará Mirim",
  "Jaci Paraná",
  "JK",
  "Liberdade",
  "Mais Perto",
  "Nova Mamoré",
  "Nova Porto Velho",
  "Rio Madeira",
  "Tancredo Neves",
  "Tucuruí"
].each do |nome|
  Distrito.find_or_create_by!(nome: nome)
end

{
  "Eldorado" => [
    "Ancorados",
    "O maná de Deus",
    "Heróis da fé"
  ],
  "Rio Madeira" => [
    "Herdeiros do céu",
    "Os 300"
  ],
  "Nova Porto Velho" => [
    "Forjados"
  ],
  "Central PVH" => [
    "Central team"
  ]
}.each do |distrito_nome, sociedades|
  distrito = Distrito.find_by!(nome: distrito_nome)

  sociedades.each do |sociedade_nome|
    Sociedade.find_or_create_by!(nome: sociedade_nome, distrito: distrito)
  end
end

[
  [ "Futsal", 10 ],
  [ "Vôlei misto", 12 ],
  [ "Natação revezamento", 4 ],
  [ "Bom de Bíblia misto", 5 ],
  [ "Bom de lição misto", 3 ]
].each do |nome, limite|
  modalidade = Modalidade.find_or_initialize_by(nome: nome)
  modalidade.limite = limite
  modalidade.save!
end
