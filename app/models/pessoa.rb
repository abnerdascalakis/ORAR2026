class Pessoa < ApplicationRecord
  belongs_to :sexo
  has_many :inscricoes, dependent: :destroy

  def self.ransackable_attributes(_auth_object = nil)
    [ "created_at", "gmail", "id", "nome", "sexo_id", "telefone", "updated_at" ]
  end

  def self.ransackable_associations(_auth_object = nil)
    [ "inscricoes", "sexo" ]
  end
end
