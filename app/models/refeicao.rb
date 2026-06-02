class Refeicao < ApplicationRecord
  self.table_name = "refeicoes"

  belongs_to :evento
  has_many :consumo_alimentacoes, class_name: "ConsumoAlimentacao", dependent: :restrict_with_exception
  has_many :inscricoes, through: :consumo_alimentacoes

  validates :nome, :data, presence: true
  validates :nome, uniqueness: { scope: [ :evento_id, :data ] }

  scope :ordenadas, -> { order(:data, :horario_inicio, :nome) }

  def nome_com_data
    "#{nome} - #{I18n.l(data)}"
  end
end
