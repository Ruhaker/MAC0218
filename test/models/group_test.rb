require 'test_helper'

class GroupTest < ActiveSupport::TestCase
    def setup
        @group = Group.new(name: "Introdução à IA", min_credits: 12, min_subjets: 3)
    end

    test "should be valid" do
        assert @group.valid?
    end

    test "name should be present" do
        @group.name = ""
        assert_not @group.valid?
    end
    
    test "min_credits should be an integer number" do
        @group.min_credits = 9.5
        assert_not @group.valid?
    end
  
    test "min_subjects should be an integer number" do
        @group.min_subjects = 2.3
        assert_not @group.valid?
    end
end
