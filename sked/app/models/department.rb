class Department < ActiveRecord::Base
  has_many :shifts
  has_and_belongs_to_many :employees
  
  attr_protected :shifts, :employees
  
  def open_time_formatted
    self.open_time.strftime("%I:%M %p")
  end
  
  def close_time_formatted
    self.close_time.strftime("%I:%M %p")
  end
end
