class SubjectController < ApplicationControllerAPI
  include Auth
  #
  # Creates a new subject
  #
  # For now, any supervisor can create courses, but this will change later.
  #
  def create
    response = {}
    status_code = 200

    begin
      # Must be POST request to create subject
      return unless request.post?

      # Receives parameters from the subject creation page
      subject_code            = params[:code]
      subject_name            = params[:name]
      subject_credits_class   = params[:credits_class]
      subject_credits_work    = params[:credits_work]
      subject_workload        = params[:workload]
      subject_description     = params[:description]

      # Fallback to default values for nil parameters
      subject_code            = ""  unless subject_code
      subject_name            = ""  unless subject_name
      subject_credits_class   = nil unless subject_credits_class
      subject_credits_work    = nil unless subject_credits_work
      subject_workload        = nil unless subject_workload
      subject_description     = ""  unless subject_description

      # Retrieves current user and checks if it is a supervisor
      user = get_logged_user()
      if !user
        status_code = 401
        raise 'Not logged in!'
      end
      if !user.is? "supervisor"
        status_code = 403
        raise 'User cannot edit course!'
      end

      # Create subject
      subject = Subject.create!(
        :code    			  => subject_code,
        :name   			  => subject_name,
        :credits_class  => subject_credits_class,
        :credits_work   => subject_credits_work,
        :workload   		=> subject_workload,
        :description   	=> subject_description
      )

      redirect_back fallback_location: "/"

    rescue Exception => e
      response[:status] = 'error'
      response[:error]  = "#{e}"

    else
      status_code 201
      response[:status] = 'success'
      response[:message] = 'Subject was created with success!'

    end

    render :json => response, :status => status_code
  end

  #
  # Enroll a student in a subject
  #
  # Students enroll themselves in a subject
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
      if !user.is? "student"
        status_code = 403
        raise 'Supervisor cannot edit subject!'
      end

      # Receives parameters from the subject creation page
      # If logged in user is a student
      if user.is? "student"
        # He can enroll only himself
        student_id = user.id
        subject_id  = params[:subject_id]

        return unless user.subjects.find(subject_id)
      else
        # If unknown class, do nothing
        return
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
    render :json => response, :status => status_code
  end

  #
  # changes subject progress
  # Only students can edit it
  #
  def change_progress
    response = {}
    status_code = 200

    begin
      # Must be POST request to create course
      return unless request.post?

      # Retrieves current user
      user = get_logged_user()
      return unless user

      # Checks if user user is logged and if he/she is a student
      if !user
        status_code = 401
        raise 'Not logged in!'
      elsif user.is? "supervisor"
        status_code = 403
        raise 'Supervisor cannot update subject!'
      # Student can change his/her progress in subjects
      elsif user.is? "student"
        student_id = user.id
        subject_id  = params[:subject_id]
        subject = SubjectStudent.find_by :subject_id => subject_id, :student_id => student_id
        prog = params[:progress]
        subject.progress = prog
      end


    rescue Exception => e
      response[:status] = 'error'
      response[:error]  = "#{e}"

    else
      status_code 201
      response[:status] = 'success'
      response[:message] = 'Student was enrolled with success!'

    end
    render :json => response, :status => status_code
  end

end
