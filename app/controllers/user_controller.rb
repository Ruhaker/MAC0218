require 'securerandom'
require 'time'

class UserController < ApplicationController
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
    # Close session for existing user
    #
    def close_session
        # Must be POST request to close session
        return unless request.post?

        # Get session to terminate
        session_id = params[:session_id]
        session_o = Session.find(session_id) if session_id

        # Get current user and exit if not logged in
        user = get_logged_user()
        return unless user

        # Find session to close from this user's sessions and exit if session not found
        session_o = user.sessions.find_by(session_key: session[:user_session]) unless session_o
        return unless session_o

        # If session is not this user's then don't do anything
        return if session_o.user_id != user.id

        # Finally deactivate session
        session_o[:active] = false
        session_o.save

        redirect_back fallback_location: "/"
    end

    #
    # Loads new session for existing user
    #
    def new_session
        # Must be POST request to authenticate
        return unless request.post?

        # Load params passed to here
        login_field  = params[:login_field]
        password     = params[:password]

        # Fallback to default values for nil variables
        login_field = "" unless login_field
        password    = "" unless password

        # Try to login user in
        begin
            # Search for user in database
            user = User.find_by! email: login_field

            # Calculate password hash with password given
            pw_hash = calculate_hash(user.pw_salt, password)

            # If password is correct
            if pw_hash == user.pw_hash
                # Generate 64 character random hex number for permanent session keeping
                session_key  = SecureRandom.hex 32
                # Recover user's browser
                user_browser = request.env['HTTP_USER_AGENT']
                # Recover user's ip address
                user_ipaddr  = request.remote_ip

                # Create session
                user.sessions.create!({
                    :session_key   => session_key,
                    :browser       => user_browser,
                    :ip_address    => user_ipaddr,
                    :last_accessed => Time.now,
                    :active        => true
                })

                # Record session key to rails' native session keeping mechanism
                session[:user_session]           = session_key
                # Store permanent login key to a permanent cookie
                cookies.permanent[:user_session] = session_key
            else
                flash[:error_msg] = "Usuário ou Senha inválida"                
            end
        rescue ActiveRecord::RecordNotFound => e
            puts e
        rescue ActiveRecord::RecordInvalid => e
            puts e
        end
        
        redirect_back fallback_location: "/"
    end
end
