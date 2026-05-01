# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

admin = User.find_or_initialize_by(email: "oraradm2026@orar.ro")
if admin.new_record?
  admin.password = "Orar26Adm"
  admin.password_confirmation = "Orar26Adm"
end
admin.admin = true
admin.save!

evento = Evento.find_or_initialize_by(descricao: "ORAR 2026")
evento.ano = 2026
evento.data_inicio = Date.new(2026, 6, 4)
evento.data_fim = Date.new(2026, 6, 7)
evento.status = "ativo"
evento.save!

[ "Masculino", "Feminino" ].each do |nome|
  Sexo.find_or_create_by!(nome: nome)
end

[ "Outro",
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
  "Tucuruí",
  "Humaitá"
].each do |nome|
  Distrito.find_or_create_by!(nome: nome)
end

dodgeball = Modalidade.find_by(nome: "Dodgeball")
dodgeball_misto = Modalidade.find_by(nome: "Dodgeball misto")

if dodgeball_misto.present? && dodgeball.blank?
  dodgeball_misto.update!(nome: "Dodgeball")
elsif dodgeball_misto.present? && dodgeball_misto.inscricao_modalidades.none? && dodgeball_misto.equipes.none?
  dodgeball_misto.destroy!
end

[
  [ "Futsal", 10, false ],
  [ "Vôlei misto", 12, false ],
  [ "Natação revezamento", 4, false ],
  [ "Bom de Bíblia misto", 5, false ],
  [ "Bom de lição misto", 3, false ],
  [ "Dodgeball", 10, false ],
  [ "Torcida", nil, true ],
  [ "corrida revezamento", 4, false ]

].each do |nome, limite, individual|
  modalidade = Modalidade.find_or_initialize_by(nome: nome)
  modalidade.limite = limite
  modalidade.individual = individual
  modalidade.save!
end
