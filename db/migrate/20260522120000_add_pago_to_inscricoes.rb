class AddPagoToInscricoes < ActiveRecord::Migration[8.1]
  def change
    add_column :inscricoes, :pago, :boolean, null: false, default: false
  end
end
