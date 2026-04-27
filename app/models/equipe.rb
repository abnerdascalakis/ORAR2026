class Equipe < ApplicationRecord
  belongs_to :modalidade

  has_many :inscricao_modalidades, dependent: :nullify
  has_many :inscricoes, through: :inscricao_modalidades

  validates :nome, presence: true
  validates :nome, uniqueness: { scope: :modalidade_id }
end
