class AddDistritoToInscricoes < ActiveRecord::Migration[8.1]
  def up
    add_reference :inscricoes, :distrito, foreign_key: true

    execute <<~SQL.squish
      UPDATE inscricoes
      SET distrito_id = sociedades.distrito_id
      FROM sociedades
      WHERE inscricoes.sociedade_id = sociedades.id
    SQL

    change_column_null :inscricoes, :distrito_id, false
    change_column_null :inscricoes, :sociedade_id, true
  end

  def down
    if select_value("SELECT 1 FROM inscricoes WHERE sociedade_id IS NULL LIMIT 1")
      raise ActiveRecord::IrreversibleMigration, "Existem inscricoes sem sociedade; nao e seguro voltar sociedade_id para obrigatorio."
    end

    change_column_null :inscricoes, :sociedade_id, false
    remove_reference :inscricoes, :distrito, foreign_key: true
  end
end
