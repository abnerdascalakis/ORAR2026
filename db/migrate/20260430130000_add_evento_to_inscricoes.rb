class AddEventoToInscricoes < ActiveRecord::Migration[8.1]
  def up
    add_reference :inscricoes, :evento, foreign_key: true

    evento_id = select_value(<<~SQL.squish)
      SELECT id
      FROM eventos
      WHERE descricao = 'ORAR 2026'
      LIMIT 1
    SQL

    unless evento_id
      evento_id = select_value(<<~SQL.squish)
        INSERT INTO eventos (descricao, ano, data_inicio, data_fim, status, created_at, updated_at)
        VALUES ('ORAR 2026', 2026, '2026-06-05', '2026-06-07', 'ativo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
        RETURNING id
      SQL
    end

    execute <<~SQL.squish
      UPDATE inscricoes
      SET evento_id = #{evento_id}
      WHERE evento_id IS NULL
    SQL

    change_column_null :inscricoes, :evento_id, false
  end

  def down
    remove_reference :inscricoes, :evento, foreign_key: true
  end
end
