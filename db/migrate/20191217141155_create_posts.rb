class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.string :title, null: false
      t.text :comment
      t.integer :size
      t.integer :weight
      t.datetime :date, null: false
      t.integer :number

      t.timestamps
    end
  end
end
