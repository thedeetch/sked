class Employee < ActiveRecord::Base
  has_many :shifts
  has_many :time_offs
  has_and_belongs_to_many :departments
  
  attr_protected :shifts, :time_offs, :departments
  
  def as_json(options = { })
      h = super(options)
      h[:name] = self.display_name
      h[:hours] = self.hours(options[:date])
      h
  end
  
  def display_name
    "#{self.last_name}, #{self.first_name} #{self.middle_name}"
  end

  def hours(date)
    hours = {   
      :total_day => self.shifts.where(:start => date.beginning_of_day..date.end_of_day).sum{|x| x.duration},
      :total_week => self.shifts.where(:start => date.beginning_of_week(:sunday)..date.end_of_week(:sunday)).sum{|x| x.duration},
      # :total_month => employee.shifts.where(:start => date.beginning_of_month..date.end_of_month).sum{|x| x.duration},
      # :total_year => employee.shifts.where(:start => date.beginning_of_year..date.end_of_year).sum{|x| x.duration},
    }
  end
end
