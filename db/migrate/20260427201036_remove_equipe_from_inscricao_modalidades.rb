class RemoveEquipeFromInscricaoModalidades < ActiveRecord::Migration[8.1]
  def change
    remove_reference :inscricao_modalidades, :equipe, null: false, foreign_key: true
  end
end
