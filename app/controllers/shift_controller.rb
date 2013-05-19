class ShiftController < ApplicationController
  def change_department
    respond_to do |format|
      format.html { redirect_to :controller => "shift", :action => "index", :date => param[:date], :id => param[:department_id] }
      format.json { head :no_content }
    end
  end

  def index
    @departments = Department.all
    @department = Department.find(params[:department_id] || @departments.first)
    @date = DateTime.parse(params[:date] || Time.now.to_s)
    @urlFormat = "%Y%m%d"
    @textFormat = "%m/%d/%Y"

    first = DateTime.strptime(params[:start] || "0", '%s')
    last = DateTime.strptime(params[:end] || "0", '%s')

    @shifts = Shift.where('"department_id" = :department_id AND "end" >= :first AND "start" <= :last', {:department_id => @department.id, :first => first, :last => last})

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @shifts }
    end
  end

  def show
  end

  def new
  end

  def edit
    @departments = Department.all
    @department = Department.find(2)
    @date = params[:date] || Time.now
    @employees = Employee.all
  end

  # POST /shift
  # POST /shift.json
  def create
    @shift = Shift.new(params[:shift])
    
    respond_to do |format|
      if @shift.save
        format.json { render json: @shift, status: :created, location: @shift }
      else
        format.json { render json: @shift.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @shift = Shift.find(params[:id])

    respond_to do |format|
      if @shift.update_attributes(params[:shift])
        format.html { redirect_to @shift, notice: 'Employee was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @shift.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @shift = Shift.find(params[:id])
    @shift.destroy

    respond_to do |format|
      format.html { redirect_to employees_url }
      format.json { head :no_content }
    end
  end
  
  def resources
    @department = Department.find(params[:department_id])
    @date = DateTime.parse(params[:date] || Time.now.to_s)
    @shifts = Shift.where(:department_id => @department.id,  :start => @date..(@date + 1))
    @resources = (@department.employees + @shifts.map(&:employee)).uniq
    
    respond_to do |format|
      format.json { render :json => @resources }
    end
  end
end
