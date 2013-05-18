class Shift < ActiveRecord::Base
  belongs_to :employee
  belongs_to :department
  
  attr_accessible :start, :end, :department_id, :employee_id

  def as_json(options = { })
      h = super(options)
      h['title'] = self.department.name
      h['allDay'] = false
      h['resource'] = self.employee_id
      h['duration'] = self.duration
      h
  end

  def duration
  	(self.end - self.start) / 1.hour
  end
end
