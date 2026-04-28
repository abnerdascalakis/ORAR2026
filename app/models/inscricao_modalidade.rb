class InscricaoModalidade < ApplicationRecord
  belongs_to :modalidade
  belongs_to :inscricao
  has_many :membro_equipes, dependent: :destroy
  has_many :equipes, through: :membro_equipes

  def self.ransackable_attributes(_auth_object = nil)
    [ "created_at", "id", "inscricao_id", "modalidade_id", "updated_at" ]
  end

  def self.ransackable_associations(_auth_object = nil)
    [ "equipes", "inscricao", "membro_equipes", "modalidade" ]
  end
end
