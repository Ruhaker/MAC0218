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

    test "should have name" do
        assert @present.name
    end
    
    test "should not have name" do
        assert_not @empty.name
    end

    test "should have credits" do
        assert @present.credits
    end

    test "should not have credits" do
        assert_not @empty.credits
    end

    test "should have teaching_unit" do
        assert @present.teaching_unit
    end

    test "should not have teaching_unit" do
        assert_not @empty.teaching_unit
    end

    test "should have expected_time" do
        assert @present.expected_time
    end

    test "should not have expected_time" do
        assert_not @empty.expected_time
    end

    test "credits should be integer" do
        assert @present.credits.is_a?(Integer)
    end

    test "expected_time should be integer" do
        assert @present.expected_time.is_a?(Integer)
    end
end
