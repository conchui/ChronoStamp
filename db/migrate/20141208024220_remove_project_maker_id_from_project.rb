class RemoveProjectMakerIdFromProject < ActiveRecord::Migration
  def change
    remove_column :projects, :project_maker_id, :integer
  end
end
