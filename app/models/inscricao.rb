class Inscricao < ApplicationRecord
  self.table_name = "inscricoes"

  belongs_to :a_sexo
  belongs_to :a_distrito
  belongs_to :a_sociedade
  has_many :inscricao_modalidades, dependent: :destroy
  has_many :a_modalidades, through: :inscricao_modalidades
end
