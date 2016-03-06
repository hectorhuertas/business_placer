class CreateNeighborhoods < ActiveRecord::Migration
  def change
    enable_extension('citext')

    create_table :neighborhoods do |t|
      t.citext :name
      t.float :area
      t.integer :population
      t.float :density
      t.references :city, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
