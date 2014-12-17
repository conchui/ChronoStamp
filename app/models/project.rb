class Project < ActiveRecord::Base
  belongs_to :user
  has_many :users,
          through: :project_makers,
          foreign_key: "user_id"
  has_many :project_makers
  has_many :tasks

  before_save do |project|
    project.name = name.titleize
    project.description = description.capitalize
  end

  validates :name, presence: true
  validates :description, presence: true
  validates :deadline, presence: true
  validates :user_id, presence: true
  
end
