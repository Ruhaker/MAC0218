require 'test_helper'

class GroupTest < ActiveSupport::TestCase
    def setup
        @present = Group.new(
            name:         Faker::Name.name,
            min_credits:  Faker::Number.number(4),
            min_subjects: Faker::Number.number(2)
        )
        @empty = Group.new(
            name:         nil,
            min_credits:  nil,
            min_subjects: nil
        )

    end

    test "should have name" do
        assert @present.name
    end

    test "should not have name" do
        assert_not @empty.name
    end

    test "should have min_credits" do
        assert @present.min_credits
    end

    test "should not have min_credits" do
        assert_not @empty.min_credits
    end

    test "should have min_subjects" do
        assert @present.min_subjects
    end

    test "should not have min_subjects" do
        assert_not @empty.min_subjects
    end

    test "min_credits should be integer" do
        assert @present.min_credits.is_a?(Integer)
    end

    test "min_subjects should be an integer" do
        assert @present.min_subjects.is_a?(Integer)
    end
end
