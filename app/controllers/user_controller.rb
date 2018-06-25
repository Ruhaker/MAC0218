require 'securerandom'
require 'time'

class UserController < ApplicationControllerAPI
    include Auth

    #
    # List all users in database
    # - ONLY IN DEVELOPMENT
    #
    def list
        @user = get_logged_user()
        if Rails.env.development? and not Rails.env.test?
            @user_list    = User.all
            @list_message = (
                "Atualmente há " +
                @user_list.count.to_s +
                " usuário#{'s' unless @user_list.count == 1} no banco de dados:"
            )
        else
            # Empty array if not development
            @user_list    = Array.new
            @list_message = "Você não pode listar usuários!"
        end
    end

    #
    # Get user object from session key
    #
    def fetch
        response = {}
        status_code = 200
        begin
            # Must be POST request to get user
            return unless request.post?

            # Fetch session key
            session_key = params[:auth][:session_key]
            if !session_key
                response = {}
                status_code = 401
                raise 'Must be logged in'
            end

            # Fetch session from DB
            session = Session.find_by(:session_key => session_key)
            if !session
                response = {}
                status_code = 404
                raise 'No session was found with this session key'
            end

            # Fetch this session's user
            user = session.user
            if !user
                response = {}
                status_code = 500
                puts 'Session does not belong to a valid user'
                raise 'Internal Server Error!'
            end

            response[:user] = {}
            response[:user][:type]  = user.type
            response[:user][:name]  = user.name
            response[:user][:email] = user.email

            if user.is? 'student'
                response[:user][:plans] = []
                user.plans.each do |plan|
                    user_plan = {}
                    user_plan[:id] = plan.id
                    user_plan[:course] = plan.course.name
                    user_plan[:start_year] = plan.start_year
                    response[:user][:plans].push user_plan
                end
            end
        rescue Exception => e
            response[:status] = 'error'
            response[:error]  = "#{e}"
        else
            status_code = 200
            response[:status] = 'success'
        end

        render :json => response, :status => status_code
    end

    #
    # Close session for existing user
    #
    def close_session
        response = {}
        status_code = 200
        begin
            # Must be POST request to close session
            return unless request.post?

            # Get session to terminate
            session_id  = params[:session_id]
            session_key = params[:session_key]
            if (!session_id and !session_key)
                response = {}
                status_code = 400
                raise 'Must provide a maximum of one of session_id and session_key'
            end
            session_o = Session.find(session_id) if session_id

            # Get current user and exit if not logged in
            user = get_logged_user()
            if !user
                response = {}
                status_code = 401
                raise 'Must be logged in'
            end

            # Find session to close from this user's sessions and exit if session not found
            session_o = user.sessions.find_by(session_key: session_key) unless session_o
            if !session_o
                response = {}
                status_code = 404
                raise 'Session was not found'
            end

            # If session is not this user's then don't do anything
            if  session_o.user_id != user.id
                response = {}
                status_code = 403
                raise 'Cannot close session belonging to another user'
            end

            # Finally deactivate session
            session_o[:active] = false
            session_o.save
        rescue Exception => e
            response[:status] = 'error'
            response[:error]  = "#{e}"
        else
            status_code = 200
            response[:status]  = 'success'
            response[:message] = 'User logged out with success'
        end

        render :json => response, :status => status_code
    end

    #
    # Loads new session for existing user
    #
    def new_session
        response = {}
        status_code = 200
        begin
            # Must be POST request to authenticate
            return unless request.post?

            # Load params passed to here
            email        = params[:email]
            password     = params[:password]
            user_client  = params[:client]

            # Fallback to default values for nil variables
            email       = "" unless email
            password    = "" unless password
            user_client = "" unless user_client

            # Search for user in database
            user = User.find_by email: email
            if !user
                response = {}
                status_code = 401
                response[:status] = 'error'
                response[:error]  = 'Invalid user or password'
            end

            # Calculate password hash with password given
            pw_hash = calculate_hash(user.pw_salt, password)

            # If password is correct
            if pw_hash == user.pw_hash
                # Generate 64 character random hex number for permanent session keeping
                session_key  = SecureRandom.hex 32
                # Recover user's ip address
                user_ipaddr  = request.remote_ip

                # Create session
                user.sessions.create!({
                    :session_key   => session_key,
                    :browser       => user_client,
                    :ip_address    => user_ipaddr,
                    :last_accessed => Time.now,
                    :active        => true
                })

                # Send session key back to client
                response[:session_key] = session_key
            else
                response = {}
                status_code = 401
                raise 'Invalid user or password'
            end
        rescue ActiveRecord::RecordInvalid => e
            response = {}
            status_code = 500
            response[:status] = 'error'
            response[:error]  = "#{e}"
        rescue Exception => e
            response[:status] = 'error'
            response[:error]  = "#{e}"
        else
            status_code = 200
            response[:status]  = 'success'
            response[:message] = 'User logged in with success'
        end

        render :json => response, :status => status_code
    end
end
