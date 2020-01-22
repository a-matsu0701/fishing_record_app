class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.string :title, null: false
      t.text :comment
      t.integer :size
      t.integer :weight
      t.datetime :date, null: false
      t.integer :number
      t.text :index_img_path, null: false
      t.text :show_img_path, null: false
      t.references :user, index: true

      t.timestamps
    end
  end
end
