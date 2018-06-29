class StudentController < ApplicationControllerAPI
  include Auth

  #
  # Creates a new student
  #
  def create
    begin
      # Must be POST request to create user
      return unless request.post?

      # Load params passed to here
      email        = get_param(:email)
      user_fname   = get_param(:full_name)
      nusp         = get_param(:nusp)
      password     = get_param(:password)

      # Generate 10 char hex password salt for this account
      pw_salt = SecureRandom.hex 5
      pw_hash = calculate_hash(pw_salt, password)


      # If has not same email nor nusp
      if User.find_by(:email => email)
        @status_code = 409
        raise 'email is already being used by another user'
      end

      if Student.find_by(:nusp => nusp)
        @status_code = 409
        raise 'nusp is already being used by another student'
      end

      # Create student
      student = Student.create({
        :email   => email,
        :name    => user_fname,
        :nusp    => nusp,
        :pw_salt => pw_salt,
        :pw_hash => pw_hash
      })

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
end
