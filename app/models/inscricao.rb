class Inscricao < ApplicationRecord
  ESTADOS_CIVIS = {
    "solteiro" => "Solteiro",
    "casado" => "Casado"
  }.freeze

  belongs_to :evento
  belongs_to :distrito
  belongs_to :sociedade, optional: true
  belongs_to :pessoa
  has_many :inscricao_modalidades, dependent: :destroy
  has_many :modalidades, through: :inscricao_modalidades

  validates :adventista, inclusion: { in: [ true, false ] }, allow_nil: true
  validates :estado_civil, inclusion: { in: ESTADOS_CIVIS.keys }, allow_nil: true

  def self.ransackable_attributes(_auth_object = nil)
    [ "adventista", "created_at", "distrito_id", "estado_civil", "evento_id", "id", "pessoa_id", "sociedade_id", "updated_at" ]
  end

  def self.ransackable_associations(_auth_object = nil)
    [ "distrito", "evento", "inscricao_modalidades", "modalidades", "pessoa", "sociedade" ]
  end

  def adventista_label
    return "Nao informado" if adventista.nil?

    adventista? ? "Sim" : "Nao"
  end

  def estado_civil_label
    ESTADOS_CIVIS.fetch(estado_civil, "Nao informado")
  end
end
