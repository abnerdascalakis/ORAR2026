class InscricaoModalidade < ApplicationRecord
  belongs_to :modalidade
  belongs_to :inscricao
  belongs_to :equipe, optional: true
end
