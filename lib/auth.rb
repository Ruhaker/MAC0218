require 'digest'

module Auth
    def calculate_hash(pw_salt, password)
        Digest::SHA256.hexdigest pw_salt+password
    end
end