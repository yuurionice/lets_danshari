class AddCompletedToItems < ActiveRecord::Migration[7.2]
  def change
    add_column :items, :completed, :boolean, default: false
  end
end
