require 'test_helper'

include Auth

class StudentTest < ActiveSupport::TestCase
    def setup
        salt = SecureRandom.hex(5)
        # Student with password = 123
        @present = Student.new(
            name:    Faker::Name.name,
            nusp:    Faker::Number.between(1,1000000),
            email:   Faker::Internet.email,
            pw_salt: salt,
            pw_hash: calculate_hash(salt, "123")
        )
        @empty = Student.new(
            name:    nil,
            nusp:    nil,
            email:   nil,
            pw_salt: nil,
            pw_hash: nil
        )
    end

    test "should have name" do
        assert @present.name
    end

    test "should not have name" do
        assert_not @empty.name
    end

    test "should have nusp" do
        assert @present.nusp
    end

    test "should not have nusp" do
        assert_not @empty.nusp
    end

    test "should have email" do
        assert @present.email
    end

    test "should not have email" do
        assert_not @empty.email
    end

    test "name should be a string" do
        assert @present.name.is_a?(String)
    end
    
    test "nusp should be an integer" do
        assert @present.nusp.is_a?(Integer)
    end

    test "email should be valid" do
        email_regex = /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
        assert email_regex.match?(@present.email)
    end    
end
