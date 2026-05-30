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

distritais = User.find_or_initialize_by(email: "distritais@orar.ro")
distritais.password = "Adm.Distritais"
distritais.password_confirmation = "Adm.Distritais"
distritais.admin = true
distritais.save!

pastores = User.find_or_initialize_by(email: "pastores@orar.ro")
pastores.password = "Adm.Pastores"
pastores.password_confirmation = "Adm.Pastores"
pastores.admin = true
pastores.save!

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
  "Acre",
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

def rename_modalidade(from, to)
  source = Modalidade.find_by(nome: from)
  return if source.blank?

  target = Modalidade.find_by(nome: to)
  if target.blank?
    source.update!(nome: to)
  elsif source.inscricao_modalidades.none? && source.equipes.none?
    source.destroy!
  end
end

rename_modalidade("Futsal", "Futsal masculino")
rename_modalidade("Natação revezamento", "Natação revezamento masculino")
rename_modalidade("Dodgeball", "Dodgeball masculino")
rename_modalidade("Dodgeball misto", "Dodgeball masculino")
rename_modalidade("corrida revezamento", "Corrida revezamento masculino")

[
  [ "Futsal masculino", 10, 16, false, "masculino" ],
  [ "Futsal feminino", 10, 16, false, "feminino" ],
  [ "Vôlei misto", 12, 12, false, "misto" ],
  [ "Natação revezamento masculino", 4, nil, false, "masculino" ],
  [ "Natação revezamento feminino", 4, nil, false, "feminino" ],
  [ "Bom de Bíblia misto", 5, nil, false, "misto" ],
  [ "Bom de lição misto", 5, nil, false, "misto" ],
  [ "Dodgeball masculino", 10, nil, false, "masculino" ],
  [ "Dodgeball feminino", 10, nil, false, "feminino" ],
  [ "Torcida", nil, nil, true, "misto" ],
  [ "Corrida revezamento masculino", 4, nil, false, "masculino" ],
  [ "Corrida revezamento feminino", 4, nil, false, "feminino" ]

].each do |nome, limite_membros_por_equipe, limite_equipes, individual, categoria_genero|
  modalidade = Modalidade.find_or_initialize_by(nome: nome)
  modalidade.limite_membros_por_equipe = limite_membros_por_equipe
  modalidade.limite_equipes = limite_equipes
  modalidade.individual = individual
  modalidade.categoria_genero = categoria_genero
  modalidade.save!
end
