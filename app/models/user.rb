class User < ApplicationRecord
    #has_one :supervisor
    #has_one :student

    has_many :sessions

    # Validations
    email_regex = /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i

    validates :name, presence: true

    validates :email, presence: true, format: {
        with: email_regex,
        message: "is not a valid e-mail"
    }

    validates :pw_hash, presence: true, format: {
        with: /[a-z0-9]{64}/
    }

    validates :pw_salt, presence: true, format: {
        with: /[a-z0-9]{10}/
    }

    def is?(cls)
        return type.casecmp(cls) == 0
    end
end
