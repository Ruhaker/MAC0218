require 'test_helper'

class CourseTest < ActiveSupport::TestCase
    def setup
        @course = Course.new(
            name: "Ciência da Computação",
            credits: 195,
            teaching_unit: "IME",
            expected_time: 8
            )
    end

    test "should be valid" do
        assert @course.valid?
    end

    test "name should be present" do
        @course.name = ""
        assert_not @course.valid?
    end
    
    test "credits should be present" do
        @course.credits = ""
        assert_not @course.valid?
    end
    
    test "teaching_unit should be present" do
        @course.teaching_unit = ""
        assert_not @course.valid?
    end
    
    test "credits should be an integer number" do
        @course.credits = 19.5
        assert_not @course.valid?
    end

    test "expected_time should be an integer number" do
        @course.expected_time = 7.5
        assert_not @course.valid?
    end
end
