class AddSequenciaToPresencas < ActiveRecord::Migration[8.1]
  def up
    add_column :presencas, :sequencia, :integer, null: false, default: 1

    remove_index :presencas, [ :inscricao_id, :evento_id, :data ]
    add_index :presencas,
      [ :inscricao_id, :evento_id, :data, :sequencia ],
      unique: true,
      name: "index_presencas_unique_por_sequencia"
  end

  def down
    remove_index :presencas, name: "index_presencas_unique_por_sequencia"
    add_index :presencas, [ :inscricao_id, :evento_id, :data ], unique: true

    remove_column :presencas, :sequencia
  end
end
