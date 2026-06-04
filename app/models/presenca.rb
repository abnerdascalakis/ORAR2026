class Presenca < ApplicationRecord
  belongs_to :inscricao
  belongs_to :evento
  belongs_to :user

  validates :data, :registrada_em, presence: true
  validates :sequencia, inclusion: { in: 1..2 }
  validates :inscricao_id, uniqueness: { scope: [ :evento_id, :data, :sequencia ] }
end
