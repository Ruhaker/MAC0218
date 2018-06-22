require 'digest'
require 'time'

module Auth
    def calculate_hash(pw_salt, password)
        Digest::SHA256.hexdigest pw_salt+password
    end

    def get_logged_user()
        auth = params[:auth]
        return nil unless auth

        session_o = Session.where(active: true).find_by(:session_key => auth[:session_key])
        session_o.last_accessed = Time.now if session_o
        session_o.save if session_o

        return session_o.user if session_o
        return nil
    end
end