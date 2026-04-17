class Inscricao < ApplicationRecord
  self.table_name = "inscricoes"
  belongs_to :a_sexo
  belongs_to :a_distrito
  belongs_to :a_sociedade
end
