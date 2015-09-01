class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :content
      t.integer :reminder_id
      t.string :uuid
      t.boolean :pending

      t.timestamps null: false
    end
    add_index :tasks, :reminder_id
    add_index :tasks, :uuid
  end
end
