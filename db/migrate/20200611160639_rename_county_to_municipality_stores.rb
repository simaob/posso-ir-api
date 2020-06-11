class RenameCountyToMunicipalityStores < ActiveRecord::Migration[6.0]
  def change
    rename_column :stores, :county, :municipality
  end
end
