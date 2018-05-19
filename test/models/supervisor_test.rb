require 'test_helper'

class SupervisorTest < ActiveSupport::TestCase
    def setup
        @supervisor = Supervisor.new(cpf: 87633547689)
    end

    test "should be valid" do
        assert @supervisor.valid?
    end

    test "cpf should be present" do
        @supervisor.cpf = nil
        assert_not @supervisor.valid?
    end
  
    test "cpf should be an integer number" do
        @supervisor.cpf = 876335476.89
        assert_not @supervisor.valid?
    end
    
    test "cpf validation should accept valid cpf numbers" do
        valid_cpfs = [97954367845, 10294733856, 47384563989, 37487278590, 54673988989]
        valid_cpfs.each do |valid_cpf|
            @supervisor.cpf = valid_cpf
            assert @supervisor.valid?, "#{valid_cpf.inspect} should be valid"
        end
    end
    
    test "cpf validation should reject invalid cpf numbers" do
        invalid_cpfs = [979543678.45, 102947338-56, 473.84563989, "3748727859o", 5467398898]
        invalid_cpfs.each do |invalid_cpf|
            @supervisor.cpf = invalid_cpf
            assert_not @supervisor.valid?, "#{invalid_cpf.inspect} should be invalid"
        end
    end
    
    test "cpf number should be unique" do
        duplicate_supervisor = @supervisor.dup
        @supervisor.save
        assert_not duplicate_supervisor.valid?
    end
end
