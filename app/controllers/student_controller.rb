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
      login_field  = params[:login_field]
      user_fname   = params[:full_name]
      nusp         = params[:nusp]
      password     = params[:password]

      # Fallback to default values for nil variables
      login_field = "" unless login_field
      user_fname  = "" unless user_fname
      nusp        = 0  unless nusp
      password    = "" unless password

      # Generate 10 char hex password salt for this account
      pw_salt = SecureRandom.hex 5
      pw_hash = calculate_hash(pw_salt, password)

       # Retrieves current user and checks if it is a student
      user = get_logged_user()

      # Create student
      Student.create!({
        :email   => login_field,
        :name    => user_fname,
        :nusp    => nusp,
        :pw_salt => pw_salt,
        :pw_hash => pw_hash
      })

      redirect_back fallback_location: "/"
    rescue Exception => e
      response[:status] = 'error'
      response[:error]  = "#{e}"
    else
      status_code 201
      response[:status] = 'success'
      response[:message] = 'Student was created with success!'
    end
end
