class AddDataToPresencas < ActiveRecord::Migration[8.1]
  def up
    add_column :presencas, :data, :date

    execute <<~SQL.squish
      UPDATE presencas
      SET data = DATE(registrada_em)
      WHERE data IS NULL
    SQL

    change_column_null :presencas, :data, false

    remove_index :presencas, [ :inscricao_id, :evento_id ]
    add_index :presencas, [ :inscricao_id, :evento_id, :data ], unique: true
  end

  def down
    remove_index :presencas, [ :inscricao_id, :evento_id, :data ]
    add_index :presencas, [ :inscricao_id, :evento_id ], unique: true

    remove_column :presencas, :data
  end
end
