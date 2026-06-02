class Presenca < ApplicationRecord
  belongs_to :inscricao
  belongs_to :evento
  belongs_to :user

  validates :registrada_em, presence: true
  validates :inscricao_id, uniqueness: { scope: :evento_id }
end
