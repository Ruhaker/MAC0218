require 'digest'
require 'time'

module Auth
    def calculate_hash(pw_salt, password)
        Digest::SHA256.hexdigest pw_salt+password
    end

    def get_logged_user()
        if !:json_request? and cookies[:user_session] and not session[:user_session]
            session[:user_session] = cookies[:user_session]
        end

        if session[:user_session]
            session_o = Session.where(active: true).find_by(:session_key => session[:user_session])
            session_o.last_accessed = Time.now if session_o
            session_o.save if session_o
            return session_o.user if session_o
        end

        return nil
    end
end