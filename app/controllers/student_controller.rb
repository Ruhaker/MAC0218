class StudentController < ApplicationControllerAPI
  include Auth

  #
  # Creates a new student
  #
  def create
    response = {}
    status_code = 200
    begin
      # Must be POST request to create user
      return unless request.post?

      # Load params passed to here
      email        = params[:email]
      user_fname   = params[:full_name]
      nusp         = params[:nusp]
      password     = params[:password]

      if !email or !user_fname or !nusp or !password
        response = {}
        status_code = 400
        raise 'email, full_name, nusp and password are required'
      end

      # Generate 10 char hex password salt for this account
      pw_salt = SecureRandom.hex 5
      pw_hash = calculate_hash(pw_salt, password)


      # If has not same email nor nusp
      if Student.find_by(:email => email)
        status_code = 409
        raise 'email is already being used by another user'
      end

      if Student.find_by(:nusp => nusp)
        status_code = 409
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

    rescue ActiveRecord::RecordInvalid => e
      status_code = 500
      response[:status] = 'error'
      response[:error]  = "#{e}"

    rescue Exception => e
      response[:status] = 'error'
      response[:error]  = "#{e}"
    else

      status_code = 201
      response[:status] = 'success'
    end

    render :json => response, :status => status_code
  end

end
