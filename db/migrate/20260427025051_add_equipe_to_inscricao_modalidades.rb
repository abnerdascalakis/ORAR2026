class AddEquipeToInscricaoModalidades < ActiveRecord::Migration[8.1]
  def change
    add_reference :inscricao_modalidades, :equipe, null: true, foreign_key: true
  end
end
