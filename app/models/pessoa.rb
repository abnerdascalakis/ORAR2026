class Pessoa < ApplicationRecord
  belongs_to :sexo
  has_many :inscricoes, dependent: :destroy

  validates :telefone,
    presence: true,
    length: { is: 15 },
    format: { with: /\A\(\d{2}\) \d{5}-\d{4}\z/, message: "deve estar no formato (69) 99999-9999" }

  def self.ransackable_attributes(_auth_object = nil)
    [ "created_at", "gmail", "id", "nome", "sexo_id", "telefone", "updated_at" ]
  end

  def self.ransackable_associations(_auth_object = nil)
    [ "inscricoes", "sexo" ]
  end
end
