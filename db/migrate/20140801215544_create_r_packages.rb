class CreateRPackages < ActiveRecord::Migration
  def change
    create_table :r_packages do |t|
      t.string :name
      t.text :description
      t.string :title
      t.date :date_created
      t.string :license

      t.timestamps
    end

    add_index :r_packages, :name
    add_index :r_packages, :title
  end
end
