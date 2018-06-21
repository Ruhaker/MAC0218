require 'test_helper'

class CourseTest < ActiveSupport::TestCase
    def setup
        @course = Course.create(
            name: "Curso 1",
            credits: 152,
            teaching_unit: "FFLCH",
            expected_time: 8
            )
        @course.supervisors << Supervisor.find_by!({:name => "Lucas Henrique Bahr Yau"})
        @course.supervisors << Supervisor.find_by!({:name => "André Luiz Akabane Solak"})
    end
=begin
    # Tests whether a course's main group is automatically created and deleted
    test "group auto creation and deletion test" do
        # Test automatic group creation
        course = Course.create(
            name: "Curso",
            credits: 81,
            teaching_unit: "UNIT",
            expected_time: 9
            )
        assert course.group?, "Course failed auto creating group!"

        # Test automatic group deletion
        group = course.group
        course.destroy
        assert group.destroyed?, "Course failed auto destroying group!"
    end
=end
    test "get supervisors" do
        @course.supervisors.each do |course|
            assert course.valid?
        end
    end

    test "should be valid" do
        assert_not @course.valid?
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
