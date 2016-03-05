class CreateCities < ActiveRecord::Migration
  def change
    enable_extension("citext")

    create_table :cities do |t|
      t.citext :name

      t.timestamps null: false
    end
  end
end
