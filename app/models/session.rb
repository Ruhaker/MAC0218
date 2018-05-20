class Session < ApplicationRecord
    belongs_to :user
    
    validates :session_key, presence: true, format: {
        with: /[a-z0-9]{64}/
    }
end
