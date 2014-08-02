class ManageVersionFields < ActiveRecord::Migration
  def change
    remove_column :versions, :author
    add_column :versions, :publication_date, :datetime
  end
end
