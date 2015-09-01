class CreateReminders < ActiveRecord::Migration
  def change
    create_table :reminders do |t|
      t.string :name
      t.string :uuid

      t.timestamps null: false
    end
    add_index :reminders, :uuid
  end
end
