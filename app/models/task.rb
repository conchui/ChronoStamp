class Task < ActiveRecord::Base
  belongs_to :project
  belongs_to :user
  has_many :assigned_people, 
          through: :working_tasks,
          source: :user,
          foreign_key: "user_id"
  has_many :working_tasks

  before_save { |task| task.name = name.capitalize }

  validates :name, presence: true
  validates :project_id, presence: true
  validates :user_id, presence: true
  
end
