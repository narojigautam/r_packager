class CreateAuthors < ActiveRecord::Migration
  def change
    create_table :authors do |t|
      t.string :name
      t.string :email

      t.timestamps
    end

    create_table :version_committers do |t|
      t.references :author
      t.references :version
      t.string :role
    end

    add_index :authors, :email
  end
end
