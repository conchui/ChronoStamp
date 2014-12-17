class User < ActiveRecord::Base

  belongs_to :role
  has_many :trackers
  has_many :projects
  has_many :project,
          through: :project_makers,
          foreign_key: "project_id"
  has_many :project_makers
  has_many :tasks
  has_many :working_tasks
  has_many :tasks_working, 
          through: :working_tasks,
          source: :task,
          foreign_key: "task_id"

  has_secure_password

  before_save do |user|
    user.email = email.downcase
    user.first_name = first_name.titleize
    user.last_name = last_name.titleize
  end

  EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  NAME_REGEX = /\A[a-zA-Z]+([\s]+[a-zA-Z]+)*\z/

  validates :first_name, presence: true,
    format: { with: NAME_REGEX }, on: :create

  validates :last_name, presence: true,
    format: { with: NAME_REGEX }, on: :create

  validates :email, presence: true,
    format: { with: EMAIL_REGEX },
    uniqueness:true, on: :create

  validates :password, presence: true,
    length: { minimum: 6 }, on: :create  
end