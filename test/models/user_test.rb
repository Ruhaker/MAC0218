require 'test_helper'

class UserTest < ActiveSupport::TestCase
    def setup
        # Supervisor with password = 321
        @supervisor_data = {
            :name    => 'Supervisor User',
            :cpf     => 63527485734,
            :email   => 'superuser@email.com',
            :pw_hash => '836318eb85a5c73a3ece52e6dcc6b0bcb04be962d284832166098879c547fdbe',
            :pw_salt => 'cad8b6856d'
        }
        # Student with password = 321
        @student_data = {
            :name    => 'Student User',
            :nusp    => 9793693,
            :email   => 'studyuser@email.com',
            :pw_hash => '21b1c4d4384a571e2d72483afbd09da3c78a0640c0d24abd23a687dda52d1158',
            :pw_salt => '8b85ddaa4e'
        }
    end

    test "should find user" do
        user = User.find_by({:email => 'victorseijih@gmail.com'})
        assert user.valid?, "Should have found user with email 'victorseijih@gmail.com'"
        
        user = User.find_by({:email => 'what@gmail.com'})
        assert_not user, "Should not have found user with email 'what@gmail.com'"
    end

    test "should be valid" do
        super_user = Supervisor.new(@supervisor_data)
        assert super_user.valid?, "Supervisor test should be valid should be valid: #{@supervisor_data.to_s}"

        study_user = Student.new(@student_data)
        assert super_user.valid?, "Student test should be valid should be valid: #{@student_data.to_s}"
    end

    test "name should be present" do
        super_user = Supervisor.new(@supervisor_data)
        super_user.name = "     "
        assert_not super_user.valid?, "Blank supervisor name should not be valid!"
        
        study_user = Student.new(@student_data)
        study_user.name = "     "
        assert_not study_user.valid?, "Blank student name should not be valid!"
    end

    test "email should be present" do
        super_user = Supervisor.new(@supervisor_data)
        super_user.email = "     "
        assert_not super_user.valid?, "Blank supervisor email should not be valid!"
        
        study_user = Student.new(@student_data)
        study_user.email = "     "
        assert_not study_user.valid?, "Blank student email should not be valid!"
    end

    test "email validation should reject invalid addresses" do
        invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                               foo@bar_baz.com foo@bar+baz.com]
        invalid_addresses.each do |invalid_address|
            super_user = Supervisor.new(@supervisor_data)
            super_user.email = invalid_address
            assert_not super_user.valid?, "This supervisor email should not be valid: #{invalid_address.inspect}"
            
            study_user = Student.new(@student_data)
            study_user.email = invalid_address
            assert_not study_user.valid?, "This student email should not be valid: #{invalid_address.inspect}"
        end
    end
end
