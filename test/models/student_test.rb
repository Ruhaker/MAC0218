require 'test_helper'

include Auth

class StudentTest < ActiveSupport::TestCase
    def setup
        # Student with password = 123
        @present = Student.new(
            name:    Faker::Name.name,
            nusp:    Faker::Number.between(1,1000000),
            email:   Faker::Internet.email,
            pw_salt: 'b265ba01f7',
            pw_hash: calculate_hash(pw_salt, 123)
        )
        @empty = Student.new(
            name:    nil,
            nusp:    nil,
            email:   nil,
            pw_salt: nil,
            pw_hash: nil
        )
    end

    test "have name" do
        assert     @present.name
        assert_not @empty.name
    end

    test "have nusp" do
        assert     @present.nusp
        assert_not @empty.nusp
    end

    test "have email" do
        assert     @present.email
        assert_not @empty.email
    end

    test "name is a string" do
        assert @present.name.is_a?(String)
    end
    
    test "nusp is a integer" do
        assert @present.name.is_a?(Integer)
    end

    test "email is a string" do
        assert @present.name.is_a?(String)
    end    
end
