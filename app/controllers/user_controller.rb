require 'securerandom'
include Auth

class UserController < ApplicationController
    #
    # List all users in database
    # - ONLY IN DEVELOPMENT
    #
    def list
        if Rails.env.development? and not Rails.env.test?
            @user_list    = User.all
            @list_message = (
                "Esses são todos os " +
                @user_list.count.to_s +
                " usuários no banco de dados:"
            )
        else
            # Empty array if not development
            @user_list    = Array.new
            @list_message = "Você não pode listar usuários!"
        end
    end

    #
    # Create user
    #
    def create
    end

    #
    # Loads new session for existing user
    #
    def new_session
        # Load params passed to here
        login_field  = params[:login_field]
        password     = params[:password]

        # Fallback to default values for nil variables
        login_field = ""        unless login_field
        password    = ""        unless password

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
                Session.create!({
                    :session_key => session_key,
                    :browser     => user_browser,
                    :ip_address  => user_ipaddr
                })

                # Record user id to rails' native session keeping mechanism
                session[:user_id]                = user_id
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
    end
end
