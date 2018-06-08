require 'test_helper'

class SubjectTest < ActiveSupport::TestCase
    def setup
        @subject = Subject.create(
            code: "MAC0110",
            name: "Introdução à Computação",
            credits_class: 4,
            credits_work: 0,
            workload: 60,
            description: "Apresentação a linguagens de programação...")
        @subject.students << Student.find_by!({:name => "Gabriely Rangel Pereira"})
        @subject.students << Student.find_by!({:name => "Victor Seiji Hariki"})
    end

    # Tests the subject students
    test "verify subject students" do
        @subject.students.each do |student|
            assert @subject.students.exists?(student.id) , "Subject student should be valid: #{student.to_s}"
        end
    end

    test "should be valid" do
        assert @subject.valid?, "Subject data should be valid: #{@subject.to_s}"
    end

    test "code should be present" do
        @subject.code = ""
        assert_not @subject.valid?
    end

    test "name should be present" do
        @subject.name = ""
        assert_not @subject.valid?
    end

    test "credits _work should be present" do
        @subject.credits_work = ""
        assert_not @subject.valid?
    end

    test "credits _class should be present" do
        @subject.credits_class = ""
        assert_not @subject.valid?
    end


    test "credits_class should be an integer number" do
        @subject.credits_class = 19.5
        assert_not @subject.valid?
    end

    test "credits_work should be an integer number" do
        @subject.credits_work = 19.5
        assert_not @subject.valid?
    end

end
