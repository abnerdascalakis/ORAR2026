class Equipe < ApplicationRecord
  belongs_to :modalidade
  belongs_to :distrito, optional: true

  has_many :membro_equipes, dependent: :destroy
  has_many :inscricao_modalidades, through: :membro_equipes
  has_many :inscricoes, through: :inscricao_modalidades

  validates :nome, presence: true
  validates :nome, uniqueness: { scope: :modalidade_id }
end
