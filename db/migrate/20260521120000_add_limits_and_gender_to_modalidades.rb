class AddLimitsAndGenderToModalidades < ActiveRecord::Migration[8.1]
  def change
    rename_column :modalidades, :limite, :limite_membros_por_equipe
    add_column :modalidades, :limite_equipes, :integer
    add_column :modalidades, :categoria_genero, :string, null: false, default: "misto"
  end
end
