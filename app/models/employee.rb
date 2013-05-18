class Employee < ActiveRecord::Base
  has_many :shifts
  has_many :time_offs
  has_and_belongs_to_many :departments
  
  attr_protected :shifts, :time_offs, :departments
  
  def as_json(options = { })
      h = super(options)
      h[:name] = self.display_name
      h[:hours_this_week] = self.hours_this_week
      h
  end
  
  def display_name
    "#{self.last_name}, #{self.first_name} #{self.middle_name}  #{self.hours_this_week}"
  end

  def hours_this_week
    t_now = Time.now
    t_prev_mon_begin = t_now - (t_now.wday-1)*24*60*60 - t_now.hour*60*60 - t_now.min*60 - t_now.sec
    t_next_sun_end = t_prev_mon_begin + 7*24*60*60 - 1
    shifts = self.shifts.where(:start => t_prev_mon_begin..t_next_sun_end)
    shifts.sum{|x| x.duration}
  end
end
