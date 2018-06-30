class PlanController < ApplicationControllerAPI
  def create
    begin
      # Must be POST request
      return unless request.post?

      # Receives parameters
      course_id = get_param(:course_id)
      year      = get_param(:year)
      status    = get_param(:status, false, 'doing')

      # Verify permissions
      if !@user
        @status_code = 401
        raise 'Must be logged in'
      end

      if !@user.is? 'student'
        @status_code = 403
        raise 'User cannot create a plan'
      end

      # Get course
      course = Course.find_by({
        :id => course_id
      })

      if !course
        @status_code = 404
        raise 'This course was not found'
      end


      # Create plan for student
      plan = Plan.new({
        :start_year   => year,
        :status       => status
      })

      base_group = Group.create!({
        :name         => "Pessoal",
        :min_credits  => nil,
        :min_subjects => nil
      })

      plan.student = @user
      plan.course  = course
      plan.group   = base_group

      if !plan.valid?
        @status_code = 400
        raise 'Invalid plan'
      end

      # Save in the db
      plan.save!

      @response[:id] = plan.id

    rescue Exception => e
      @status_code = 500 if !@status_code
      @response[:status] = 'error'
      @response[:error]  = "#{e}"
    else
      @status_code = 201
      @response[:status] = 'success'
    end

    render :json => @response, :status => @status_code
  end

  def fetch
    begin
      # Must be POST request
      return unless request.post?

      # Receives parameters
      plan_id = get_param(:plan_id)

      # Find plan
      plan = Plan.find_by(:id => plan_id)

      if !plan
        @status_code = 404
        raise 'Plan was not found'
      end

      # Check permissions
      if !@user
        @status_code = 401
        raise 'Must be logged in'
      end

      if plan.student != @user
        @status_code = 403
        raise 'User not allowed to fetch this plan'
      end

      # Build response data
      @response[:plan] = {}
      @response[:plan][:id]          = plan.id
      @response[:plan][:group_id]    = plan.group.id
      @response[:plan][:c_group_id]  = plan.course.group.id

    rescue Exception => e
      @status_code = 500 if !@status_code
      @response[:status] = 'error'
      @response[:error]  = "#{e}"
    else
      @status_code = 200
      @response[:status] = 'success'
    end

    render :json => @response, :status => @status_code
  end
end
