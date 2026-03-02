class CreateArticles < ActiveRecord::Migration[8.1]
  def change
    create_table :articles do |t|
      t.string :title, null: false
      t.text :content
      t.integer :status,null: false, default: 0
      t.datetime :published_at

      t.timestamps
    end
  end
end
