class CreatePosts < ActiveRecord::Migration[5.1]
  def change
    create_table :posts do |t|
      t.references :user_id, index: true
      t.string :text, null: false, default: ''

      t.timestamps
    end
  end
end
