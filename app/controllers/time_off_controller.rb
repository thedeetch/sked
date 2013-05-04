class TimeOffController < ApplicationController
  
  def index
    @employees = Employee.all
    @date = Time.now.strftime('%Y%m%d')
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @department }
    end
  end
  
  def create
    
  end
  
  def update
    
  end
  
  def delete
    
  end
end
