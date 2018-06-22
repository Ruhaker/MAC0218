require 'test_helper'

class CourseTest < ActiveSupport::TestCase
    
    def setup
        @present = Course.new(
            name:          Faker::Name.name,
            credits:       Faker::Number.number(4),
            teaching_unit: Faker::University.name,
            expected_time: Faker::Number.number(2)
        )
        @empty = Course.new(
            name:          nil,
            credits:       nil,
            teaching_unit: nil,
            expected_time: nil    
        )
    end

    test "have name" do
        assert     @present.name
        assert_not @empty.name
    end

    test "have credits" do
        assert     @present.credits
        assert_not @empty.credits
    end

    test "have teaching_unit" do
        assert     @present.teaching_unit
        assert_not @empty.teaching_unit
    end

    test "credits is an integer number" do
        assert @present.credits.is_a?(Integer)
    end

    test "expected_time is an integer number" do
        assert @present.expected_time.is_a?(Integer)
    end
end
