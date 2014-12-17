class WorkingTask < ActiveRecord::Base
  belongs_to :user
  belongs_to :task

  validates :user_id, presence: true
  validates :task_id, presence: true
  validates_uniqueness_of :user_id, scope: :task_id

end
