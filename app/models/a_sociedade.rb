class ASociedade < ApplicationRecord
  belongs_to :a_distrito

  def to_s
    nome
  end
end
