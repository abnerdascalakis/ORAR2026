class AddIndividualToModalidades < ActiveRecord::Migration[8.1]
  def change
    add_column :modalidades, :individual, :boolean, null: false, default: false
  end
end
