class AddStateToCards < ActiveRecord::Migration[7.0]
  def change
    add_column :cards, :state, :string, default: 'non à vendre'  # Par défaut, l'état sera "non à vendre"
  end
end
