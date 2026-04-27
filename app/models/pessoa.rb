class Pessoa < ApplicationRecord
  belongs_to :sexo
  has_many :inscricoes, dependent: :destroy
end
