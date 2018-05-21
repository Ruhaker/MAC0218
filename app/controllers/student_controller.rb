class StudentController < ApplicationController
  include Auth

  def create
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

    # Create student
    Student.create!({
      :email   => login_field,
      :name    => user_fname,
      :nusp    => nusp,
      :pw_salt => pw_salt,
      :pw_hash => pw_hash
    })
    
    redirect_back fallback_location: "/"
  end
end
