require 'test_helper'

include Auth

class SupervisorTest < ActiveSupport::TestCase
    def setup
        salt = SecureRandom.hex(5)
        # Student with password = 123
        @present = Student.new(
            name:    Faker::Name.name,
            cpf:     Faker::Number.number(11),
            email:   Faker::Internet.email,
            pw_salt: salt,
            pw_hash: calculate_hash(salt, "123")
        )
        @empty = Student.new(
            name:    nil,
            cpf:    nil,
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

    test "should have cpf" do
        assert @present.cpf
    end

    test "should not have cpf" do
        assert_not @empty.cpf
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
    
    test "cpf should be an integer" do
        assert @present.cpf.is_a?(Integer)
    end

    test "cpf should have 11 digits" do
        assert @present.cpf.to_s.length == 11
    end

    test "email should be valid" do
        email_regex = /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
        assert email_regex.match?(@present.email)
    end    
end
