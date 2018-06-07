require 'test_helper'

class StudentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
    def setup
        # Student with password = 123
        @student = Student.new({
            :name    => 'Student 1',
            :nusp    => 9793692,
            :email   => 'stu1@email.com',
            :pw_hash => '215cdbc5fa64ba878835314da7daafbfdb814a534e3eb38cfcd198f30a0cf73d',
            :pw_salt => 'b265ba01f7'
            })
        @student.save
    end

    test "student_subject relationship" do
        @estat = Subject.find_by!(:name => "Estatística Descritiva")
        @prob    = Subject.find_by!(:name => "Probabilidade 1")
        @student   = Student.find_by!(:name => "Student 1")
        @student.subjects << @prob

        # 'plans' method
        assert     @student.subjects.exists?(@prob.id), "'#{@prob.name}' should be não sei #{@student.name}"
        assert     @student.subjects[0].valid?, "'#{@prob.name}' should be não sei #{@student.name}"
        assert_not @student.subjects.exists?(@estat.id), "'#{@estat.name}' should not be nao sei #{@student.name}"
    end

    test "should be valid" do
        assert @student.valid?
    end


    test "nusp should be present" do
        @student.nusp = ""
        assert_not @student.valid?
    end
end
