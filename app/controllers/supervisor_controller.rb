class SupervisorController < ApplicationController
  include Auth

  def create
    # Must be POST request to create user
    return unless request.post?
    
    # Load params passed to here
    login_field  = params[:login_field]
    user_fname   = params[:full_name]
    cpf          = params[:cpf]
    password     = params[:password]
    
    # Fallback to default values for nil variables
    login_field = "" unless login_field
    user_fname  = "" unless user_fname
    cpf         = 0  unless cpf
    password    = "" unless password
    
    # Generate 10 char hex password salt for this account
    pw_salt = SecureRandom.hex 5
    pw_hash = calculate_hash(pw_salt, password)

    # Create student
    Supervisor.create!({
      :email   => login_field,
      :name    => user_fname,
      :cpf     => cpf,
      :pw_salt => pw_salt,
      :pw_hash => pw_hash
    })
    
    redirect_back fallback_location: "/"
  end
end
