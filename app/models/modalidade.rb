class Modalidade < ApplicationRecord
  has_many :equipes, dependent: :destroy
  has_many :inscricao_modalidades, dependent: :restrict_with_exception
  has_many :inscricoes, through: :inscricao_modalidades
end
