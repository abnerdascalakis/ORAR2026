class Equipe < ApplicationRecord
  LIMITES_POR_MODALIDADE = {
    "Futsal" => 16,
    "Vôlei misto" => 12
  }.freeze

  belongs_to :modalidade
  belongs_to :distrito, optional: true

  has_many :membro_equipes, dependent: :destroy
  has_many :inscricao_modalidades, through: :membro_equipes
  has_many :inscricoes, through: :inscricao_modalidades

  validates :nome, presence: true
  validates :nome, uniqueness: { scope: :modalidade_id }
  validate :modalidade_dentro_do_limite_de_equipes, on: :create

  private

  def modalidade_dentro_do_limite_de_equipes
    return if modalidade.blank?

    limite = LIMITES_POR_MODALIDADE[modalidade.nome]
    return if limite.blank?
    return if modalidade.equipes.count < limite

    errors.add(:base, "Esta modalidade ja atingiu o limite de equipes.")
  end
end
