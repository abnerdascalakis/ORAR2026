class AddAdventistaAndEstadoCivilToInscricoes < ActiveRecord::Migration[8.1]
  def change
    add_column :inscricoes, :adventista, :boolean
    add_column :inscricoes, :estado_civil, :string
  end
end
