require 'test_helper'

class SubjectTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
def setup
        @subject = Subject.new(
            code: "MAC0110",
            name: "Introdução à Computação",
            credits_class: 4,
            credits_work: 0,
            workload: 60,
            description: "Apresentação a linguagens de programação...")
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
