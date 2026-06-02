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
  has_many :presencas, dependent: :restrict_with_exception
  has_many :consumo_alimentacoes, class_name: "ConsumoAlimentacao", dependent: :restrict_with_exception
  has_many :refeicoes_consumidas, through: :consumo_alimentacoes, source: :refeicao

  validates :adventista, inclusion: { in: [ true, false ] }, allow_nil: true
  validates :estado_civil, inclusion: { in: ESTADOS_CIVIS.keys }, allow_nil: true

  def self.ransackable_attributes(_auth_object = nil)
    [ "adventista", "created_at", "distrito_id", "estado_civil", "evento_id", "id", "pago", "pessoa_id", "sociedade_id", "updated_at" ]
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

  def pago_label
    pago? ? "Pago" : "Nao pago"
  end

  def credencial_token
    signed_id(purpose: :credencial_evento)
  end
end
