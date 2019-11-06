class CreateTasks < ActiveRecord::Migration[6.0]
  def change
    create_table :tasks do |t|
      t.string :title, null: false
      t.text :description
      t.datetime :due_date
      t.integer :status, default: Task.statuses[:in_progress]
      t.string :image
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
