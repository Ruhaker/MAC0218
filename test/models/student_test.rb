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
    end

    test "should be valid" do
        assert @student.valid?
    end


    test "nusp should be present" do
        @student.nusp = ""
        assert_not @student.valid?
    end
end
