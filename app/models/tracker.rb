class Tracker < ActiveRecord::Base
	
  extend SimpleCalendar
  has_calendar :attribute => :created_at
  
  belongs_to :user

  validates_uniqueness_of :date, scope: :user_id

end
