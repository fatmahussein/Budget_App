class CreateJoinTable < ActiveRecord::Migration[7.1]
  def change
    create_join_table :categories, :entries do |t|
      t.index [:category_id, :entry_id]
      t.index [:entry_id, :category_id]
    end
  end
end
