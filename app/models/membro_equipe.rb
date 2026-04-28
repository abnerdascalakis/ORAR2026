class MembroEquipe < ApplicationRecord
  belongs_to :equipe
  belongs_to :inscricao_modalidade

  validates :inscricao_modalidade_id, uniqueness: { scope: :equipe_id }
  validate :inscricao_da_mesma_modalidade_da_equipe

  private

  def inscricao_da_mesma_modalidade_da_equipe
    return if equipe.blank? || inscricao_modalidade.blank?
    return if equipe.modalidade_id == inscricao_modalidade.modalidade_id

    errors.add(:inscricao_modalidade, "precisa ser da mesma modalidade da equipe")
  end
end
