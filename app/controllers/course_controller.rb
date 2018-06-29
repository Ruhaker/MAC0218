class CourseController < ApplicationControllerAPI
  include Auth

  #
  # Lists courses
  #
  #
  def list
    begin
      # Must be POST request to create course
      return unless request.post?

      # Receives parameters from the course creation page
      filter = get_param(:filter)

      @response[:courses] = []

      # Find courses that fit the filter
      Course.where({
        :teaching_unit => filter[:teaching_unit]
      }).each do |course|
        course_data = {}
        course_data[:id] = course.id
        course_data[:name] = course.name

        @response[:courses].push course_data
      end
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

  #
  # Creates a new course
  #
  # For now, any supervisor can create courses, but this will change later.
  #
  def create
    begin
      # Must be POST request to create course
      return unless request.post?

      # Receives parameters from the course creation page
      course_name          = get_param(:name)
      course_credits       = get_param(:credits, false)
      course_teaching_unit = get_param(:teaching_unit)
      corse_expected_time  = get_param(:expected_time)

      course_name = course_name.strip

      # Retrieves current user and checks if it is a supervisor
      user = get_logged_user()

      if !user
        @status_code = 401
        raise 'Not logged in'
      end
      if !user.is? "supervisor"
        @status_code = 403
        raise 'User cannot create course'
      end

      # Create a course
      course = Course.new({
        :name          => course_name,
        :credits       => course_credits,
        :teaching_unit => course_teaching_unit,
        :expected_time => course_expected_time
      })

      base_group = Group.create!({
        :name         => "Grade",
        :min_credits  => nil,
        :min_subjects => nil
      })

      course.group = base_group

      if !course.valid?
        @status_code = 400
        base_group.destroy
        raise 'Invalid course data'
      end

      # Save new course
      course.save!
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

  #
  # Enroll a student in a course.
  #
  # Supervisors may only enroll students in the courses they manage.
  #
  def enroll

    response = {}
    status_code = 200

    begin

        # Must be POST request to create course
        return unless request.post?

        # Retrieves current user
        user = get_logged_user()
        return unless user

        if !user
            status_code = 401
            raise 'Not logged in!'
        end

        if !user.is? "supervisor"
            status_code = 403
            raise 'Student cannot edit course!'
        end

        # If a supervisor
        if user.is? "supervisor"
          # Get parameters
          student_id = params[:student_id]
          course_id  = params[:course_id]

          # Only allowed to enroll students in courses he supervises
          return unless user.courses.find(course_id)
        else
          # If unknown class, do nothing
          return
        end

        # Create plan
        plan = Plan.new

        group = Group.create!(
          :name         => "Pessoal",
          :min_credits  => nil,
          :min_subjects => nil
        )

        # Supervisor only enrolls if student exists
        if Student.find(student_id) != nil
            plan.course  = Course.find(course_id)
            plan.student = Student.find(student_id)
            plan.group   = group

            plan.save
        else
            status_code = 404
            raise 'Student does not exist!'
        end

        redirect_back fallback_location: "/"
    rescue Exception => e
        response[:status] = 'error'
        response[:error]  = "#{e}"
    else
        status_code 201
        response[:status] = 'success'
        response[:message] = 'Student was enrolled with success!'
    end
  end

  #
  # Assigns a course to a supervisor's management
  #
  # For now, any supervisor can assign himself to any course.
  # This will change later.
  #
  def assign
    # Must be POST request to create course
    return unless request.post?

    # Retrieves current user
    user = get_logged_user()
    return unless user
    return unless user.is? "supervisor"

    # Receives parameters from the course creation page
    course_id  = params[:course_id]

    # Get course
    course = Course.find(course_id)

    # Assign
    user.courses << course

    redirect_back fallback_location: "/"
  end
end