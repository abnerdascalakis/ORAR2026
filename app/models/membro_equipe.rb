class MembroEquipe < ApplicationRecord
  belongs_to :equipe
  belongs_to :inscricao_modalidade

  validates :inscricao_modalidade_id, uniqueness: { scope: :equipe_id }
  validate :inscricao_da_mesma_modalidade_da_equipe
  validate :equipe_dentro_do_limite_de_membros, on: :create

  private

  def inscricao_da_mesma_modalidade_da_equipe
    return if equipe.blank? || inscricao_modalidade.blank?
    return if equipe.modalidade_id == inscricao_modalidade.modalidade_id

    errors.add(:inscricao_modalidade, "precisa ser da mesma modalidade da equipe")
  end

  def equipe_dentro_do_limite_de_membros
    return if equipe.blank?
    return if equipe.modalidade.limite.blank?
    return if equipe.membro_equipes.count < equipe.modalidade.limite

    errors.add(:base, "Esta equipe ja atingiu o limite de membros.")
  end
end
