class ConsumoAlimentacao < ApplicationRecord
  self.table_name = "consumo_alimentacoes"

  belongs_to :inscricao
  belongs_to :refeicao
  belongs_to :user

  validates :consumido_em, presence: true
  validates :inscricao_id, uniqueness: { scope: :refeicao_id }
  validate :inscricao_do_mesmo_evento_da_refeicao

  private

  def inscricao_do_mesmo_evento_da_refeicao
    return if inscricao.blank? || refeicao.blank?
    return if inscricao.evento_id == refeicao.evento_id

    errors.add(:inscricao, "precisa pertencer ao mesmo evento da refeicao")
  end
end
