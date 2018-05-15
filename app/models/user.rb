class User < ApplicationRecord
    validates :name, presence: true

    validates :email, presence: true, format: {
        with: /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i,
        message: "is not a valid e-mail"
    }

    validates :pw_hash, presence: true, format: {
        with: /[a-z0-9]{64}/
    }

    validates :pw_salt, presence: true, format: {
        with: /[a-z0-9]{10}/i
    }

    def self.types
        %w(Student)
    end
end
