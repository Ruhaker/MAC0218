require 'test_helper'

class StudentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
    def setup
        @student = Student.new(nusp: 9792571)
    end

    test "should be valid" do
        assert @student.valid?
    end


    test "nusp should be present" do
        @student.nusp = ""
        assert_not @student.valid?
    end

    test "nusp should be an integer number" do
        @student.nusp = 19.5
        assert_not @student.valid?
    end


end
