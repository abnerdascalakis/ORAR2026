class Distrito < ApplicationRecord
  has_many :inscricoes, dependent: :restrict_with_exception
  has_many :sociedades, dependent: :restrict_with_exception

  def self.ransackable_attributes(_auth_object = nil)
    [ "created_at", "id", "nome", "updated_at" ]
  end

  def self.ransackable_associations(_auth_object = nil)
    [ "inscricoes", "sociedades" ]
  end
end
