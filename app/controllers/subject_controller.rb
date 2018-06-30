class SubjectController < ApplicationControllerAPI
  include Auth

  #
  # List subjects according to a text field
  #
  def list
    begin
      # Must be POST request to create course
      return unless request.post?

      # Receives search string
      search = get_param(:search)

      @response[:subjects] = []

      # Find subjects that fit the search string
      Subject.search(search).each do |subject|
        course_data = {}
        puts subject
        course_data[:id]   = subject.id
        course_data[:type] = 'new_subject'
        course_data[:code] = subject.code
        course_data[:name] = subject.name

        @response[:subjects].push course_data
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

  def update
    begin
      # Must be POST request to retrieve group
      return unless request.post?

      # Receives parameters
      subject_id        = get_param(:subject_id)
      new_code          = get_param(:code, false)
      new_name          = get_param(:name, false)
      new_description   = get_param(:description, false)
      new_progress      = get_param(:progress, false)

      changes = {}
      changes[:progress]      = new_progress if new_progress

      if changes.size == 0
        @status_code = 400
        raise 'At least one change is required'
      end

      if new_progress && @user.is?('supervisor')
        @status_code = 400
        raise 'Only students may change progress'
      end

      # Check if user can retrieve group
      subject = Subject.find_by(:id => subject_id)

      if !subject
        @status_code = 404
        raise 'Subject was not found'
      end

      if changes.size > 1 || !changes[:progress]
        if !@user.is? 'supervisor'
          @status_code = 403
          raise 'User not allowed to change this subject'
        end
      end

      # If progress changed, get user's subject relationship
      if changes[:progress]
        rel = SubjectStudent.find_by(
          :student_id => @user.id,
          :subject_id => subject.id)

        if !rel
          rel = SubjectStudent.new({
            :progress   => changes[:progress]
          })

          rel.student = @user
          rel.subject = @subject

          if !rel.valid?
            @status_code = 500
            raise 'Failed creating relationship'
          end

          rel.save
        else
          rel.progress = changes[:progress]
          rel.save
        end
      end

      # Change data in subject
      subject.update(changes)

      if !subject.valid?
        @status_code = 400
        raise 'Invalid changes'
      end

      # Save changes
      subject.save
    rescue Exception => e
      @status_code = 500 unless @status_code
      @response[:status] = 'error'
      @response[:error]  = "#{e}"
    else
      @status_code = 200
      @response[:status]  = 'success'
    end

    render :json => @response, :status => @status_code
  end

  #
  # Retrieves a subject
  #
  def fetch
    begin
      # Must be POST request to create course
      return unless request.post?

      # Receives subject id
      subject_id = get_param(:subject_id)

      @response[:subject] = {}

      # Find subject
      subject = Subject.find_by(:id => subject_id)

      if !subject
        @status_code = 404
        raise 'Subject was not found'
      end

      @response[:subject][:id]            = subject.id
      @response[:subject][:credits_class] = subject.credits_class
      @response[:subject][:credits_work]  = subject.credits_work
      @response[:subject][:code]          = subject.code
      @response[:subject][:name]          = subject.name
      @response[:subject][:description]   = subject.description
      @response[:subject][:description]   = 'Descrição vazia' if subject.description.empty?
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
  # Creates a new subject
  #
  def create
    begin
      # Must be POST request to create subject
      return unless request.post?

      # Receives parameters from the subject creation page
      subject_code            = get_param(:code)
      subject_name            = get_param(:name)
      subject_credits_class   = get_param(:credits_class)
      subject_credits_work    = get_param(:credits_work)
      subject_workload        = get_param(:workload)
      subject_description     = get_param(:description)

      # Retrieves current user and checks if it is a supervisor
      if !@user
        @status_code = 401
        raise 'Not logged in!'
      end
      if !@user.is? "supervisor"
        @status_code = 403
        raise 'User cannot edit course!'
      end

      # Create subject
      subject = Subject.new(
        :code    			  => subject_code,
        :name   			  => subject_name,
        :credits_class  => subject_credits_class,
        :credits_work   => subject_credits_work,
        :workload   		=> subject_workload,
        :description   	=> subject_description
      )

      if !subject.valid?
        @status_code = 400
        raise 'Invalid data from subject'
      end

      subject.save

      @response[:id] = subject.id

    rescue Exception => e
      @response[:status] = 'error'
      @response[:error]  = "#{e}"

    else
      @status_code = 201
      @response[:status] = 'success'
    end

    render :json => @response, :status => @status_code
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
