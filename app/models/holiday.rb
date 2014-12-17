class Holiday < ActiveRecord::Base
  extend SimpleCalendar
  has_calendar :attribute => :holiday_date
  
end
