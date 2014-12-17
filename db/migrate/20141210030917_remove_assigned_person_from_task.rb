class RemoveAssignedPersonFromTask < ActiveRecord::Migration
  def change
    remove_column :tasks, :assigned_person, :integer
  end
end
