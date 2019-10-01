class AddForToLists < ActiveRecord::Migration[5.2]
  def change
    add_column :lists, :created_for, :integer
  end
end
