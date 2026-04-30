class Evento < ApplicationRecord
  has_many :inscricoes, dependent: :restrict_with_exception
end
