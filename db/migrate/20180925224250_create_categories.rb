class CreateCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :categories do |t|
      t.string :title, null: false
      t.integer :books_count
    end
  end
end
