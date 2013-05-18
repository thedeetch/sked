class Employee < ActiveRecord::Base
  has_many :shifts
  has_many :time_offs
  has_and_belongs_to_many :departments
  
  attr_protected :shifts, :time_offs, :departments
  
  def as_json(options = { })
      h = super(options)
      h[:name] = self.display_name
      h
  end
  
  def display_name
    "#{self.last_name}, #{self.first_name} #{self.middle_name}"
  end
end
