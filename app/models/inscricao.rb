class Inscricao < ApplicationRecord
  belongs_to :sociedade
  belongs_to :pessoa
  has_many :inscricao_modalidades, dependent: :destroy
  has_many :modalidades, through: :inscricao_modalidades
end
