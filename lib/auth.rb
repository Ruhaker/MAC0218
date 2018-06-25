require 'digest'
require 'time'

module Auth
    def calculate_hash(pw_salt, password)
        Digest::SHA256.hexdigest pw_salt+password
    end

    def get_logged_user()
        auth = params[:auth]
        return nil unless auth

        session_o = nil

        session_key = auth[:session_key]

        session_o = Session.where(:active => true).find_by(:session_key => session_key)

        Thread.new do
            retry_cnt = 3
            begin
                if session_o
                    session_o.last_accessed = Time.now
                    session_o.save
                end
            rescue ActiveRecord::StatementInvalid => e
                retry_cnt -= 1
                if retry_cnt > 0
                    sleep rand
                    retry
                end
            end
            ActiveRecord::Base.connection.close
        end if false

        if session_o
            return session_o.user
        else
            return nil
        end
    end
end