class AddUniqueIndexToMembroEquipes < ActiveRecord::Migration[8.1]
  def change
    add_index :membro_equipes,
      [ :equipe_id, :inscricao_modalidade_id ],
      unique: true,
      name: "index_membro_equipes_on_equipe_and_inscricao"
  end
end
