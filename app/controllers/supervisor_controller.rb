class SupervisorController < ApplicationControllerAPI
  include Auth

  def list
    begin
      # Must be POST request to create user
      return unless request.post?

      # Verify permissions
      if !@user
        @status_code = 401
        raise 'Must be logged in to list supervisors'
      end

      if !@user.is_admin
        @status_code = 403
        raise 'Must be admin to list supervisors'
      end

      @response[:supervisors] = []

      # Fetch data
      Supervisor.all.each do |supervisor_obj|
        supervisor = {}
        supervisor[:id] = supervisor_obj.id
        supervisor[:name] = supervisor_obj.name
        supervisor[:email] = supervisor_obj.email
        @response[:supervisors].push supervisor
      end

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

  def create
    begin
      # Must be POST request to create user
      return unless request.post?

      # Load params passed to here
      email        = get_param(:email)
      user_fname   = get_param(:full_name)
      cpf          = get_param(:cpf)
      password     = get_param(:password)

      # Generate 10 char hex password salt for this account
      pw_salt = SecureRandom.hex 5
      pw_hash = calculate_hash(pw_salt, password)


      # If has not same email nor nusp
      if User.find_by(:email => email)
        @status_code = 409
        raise 'email is already being used by another user'
      end

      if Supervisor.find_by(:cpf => cpf)
        @status_code = 409
        raise 'cpf is already being used by another user'
      end

      # Create student
      student = Supervisor.create({
        :email   => email,
        :name    => user_fname,
        :cpf    => cpf,
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
