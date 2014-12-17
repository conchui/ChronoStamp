class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name
      t.text :description
      t.date :deadline
      t.integer :user_id
      t.integer :project_maker_id

      t.timestamps
    end
  end
end
