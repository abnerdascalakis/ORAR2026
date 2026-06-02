class Evento < ApplicationRecord
  has_many :inscricoes, dependent: :restrict_with_exception
  has_many :presencas, dependent: :restrict_with_exception
  has_many :refeicoes, class_name: "Refeicao", dependent: :restrict_with_exception
end
