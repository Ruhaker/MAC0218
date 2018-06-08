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
        @subject.groups   << Group.find_by!({:name => "Des. de Software"})
        @subject.groups   << Group.find_by!({:name => "Obrigatórias"})
    end 
    
    # Tests the subject students
    test "subject students should exist" do
        @subject.students.each do |student|
            assert @subject.students.exists?(student.id) , "Subject student should be valid: #{student.to_s}"
        end
    end

    test "subject student shouldn't exist" do
    	@student = Student.find_by!({:name => "José Alves Garcia"})
    	assert_not @subject.students.exists?(@student.id), "Subject student shouldn't be valid: #{@student.to_s}"
    end

    test "subject groups should exist" do
    	@subject.groups.each do |group|
    		assert @subject.groups.exists?(group.id), "Subject group should be valid: #{group.to_s}"
    	end
    end

    test "subject group shouldn't exist" do
    	@group = Group.find_by!({:name => "Opt. de Estatística"})
    	assert_not @subject.groups.exists?(@group.id), "Subject group shouldn't be valid: #{@group.to_s}"
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
