class CreatePosts < ActiveRecord::Migration[7.2]
  def change
    return if table_exists?(:posts)
    create_table :posts do |t|
      t.string :title
      t.string :user_name
      t.string :image
      t.integer :amount
      t.text :comment
      t.references :item, null: false, foreign_key: true

      t.timestamps
    end
  end
end
