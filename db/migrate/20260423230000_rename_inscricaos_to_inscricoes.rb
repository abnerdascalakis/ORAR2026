class RenameInscricaosToInscricoes < ActiveRecord::Migration[8.1]
  def change
    rename_table :inscricaos, :inscricoes
  end
end
