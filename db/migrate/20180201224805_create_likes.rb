class CreateLikes < ActiveRecord::Migration[5.1]
  def change
    create_table :likes do |t|
      t.references :user, index: true
      t.references :post, index: true

      t.timestamps
    end

    add_index :likes, %i[user_id post_id], unique: true
  end
end
