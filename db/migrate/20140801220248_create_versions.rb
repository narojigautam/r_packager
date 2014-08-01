class CreateVersions < ActiveRecord::Migration
  def change
    create_table :versions do |t|
      t.string :number
      t.string :author
      t.date :released_on
      t.string :dependency
      t.boolean :lazy_data
      t.string :repository
      t.references :r_package

      t.timestamps
    end

    add_index :versions, :number
    add_index :versions, :author
  end
end
