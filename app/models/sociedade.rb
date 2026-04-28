class Sociedade < ApplicationRecord
  belongs_to :distrito
  has_many :inscricoes, dependent: :restrict_with_exception

  delegate :nome, to: :distrito, prefix: true, allow_nil: true

  def self.ransackable_attributes(_auth_object = nil)
    [ "created_at", "distrito_id", "id", "nome", "updated_at" ]
  end

  def self.ransackable_associations(_auth_object = nil)
    [ "distrito", "inscricoes" ]
  end
end
