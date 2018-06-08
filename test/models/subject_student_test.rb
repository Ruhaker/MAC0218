require 'test_helper'

class SubjectStudentTest < ActiveSupport::TestCase
    # test "the truth" do
    #   assert true
    # end
    def setup
        @prob = Subject.find_by!({name: "Probabilidade 1"})
        @student = Student.find_by!({name: "Gabriely Rangel Pereira"})
        @subject_stu = SubjectStudent.create(
            subject_id: @prob.id,
            student_id: @student.id,
            progress: 2)
    end

    test "the subject should be studied by this student" do
        assert @subject_stu.progress == 2
    end
end

