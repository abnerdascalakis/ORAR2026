class Sociedade < ApplicationRecord
  belongs_to :distrito
  has_many :inscricoes, dependent: :restrict_with_exception
end
