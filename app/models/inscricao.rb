class Inscricao < ApplicationRecord
  belongs_to :distrito
  belongs_to :sociedade, optional: true
  belongs_to :pessoa
  has_many :inscricao_modalidades, dependent: :destroy
  has_many :modalidades, through: :inscricao_modalidades

  def self.ransackable_attributes(_auth_object = nil)
    [ "created_at", "distrito_id", "id", "pessoa_id", "sociedade_id", "updated_at" ]
  end

  def self.ransackable_associations(_auth_object = nil)
    [ "distrito", "inscricao_modalidades", "modalidades", "pessoa", "sociedade" ]
  end
end
