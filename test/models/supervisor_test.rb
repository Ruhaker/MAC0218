require 'test_helper'

class SupervisorTest < ActiveSupport::TestCase
    def setup
        # Supervisor with password = 123
        @supervisor = Supervisor.create(
            name: 'Supervisor 1',
            cpf: 87633547689,
            email: 'email@email.com',
            pw_hash: '51f3395b4f88d87f58fc1e5e5de04a1dcf5b03ea321121be4d0ade81861dca20',
            pw_salt: '7901253e91'
            )
        
        @supervisor.save
    end

    test "supervises relationship" do
        @architecture = Course.find_by!(:name => "Arquitetura e Urbanismo")
        @computing    = Course.find_by!(:name => "Ciência da Computação")
        @supervisor   = Supervisor.find_by!(:name => "Supervisor 1")
        @supervisor.courses << @architecture

        # 'supervises?' method
        assert     @supervisor.supervises?(@architecture), "'#{@architecture.name}' should be supervised by #{@supervisor.name}"
        assert_not @supervisor.supervises?(@computing), "'#{@architecture.name}' should not be supervised by #{@supervisor.name}"
    
        @supervisor.courses << @computing
        assert     @supervisor.supervises?(@computing), "'#{@architecture.name}' should be supervised by #{@supervisor.name}"
    end

    test "should be valid" do
        assert @supervisor.valid?, "Supervisor #{@supervisor.name} should be valid!"
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
        invalid_cpfs = [979543678.45, 102947338-56, 473.84563989, "3748727859o", 539898]
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
