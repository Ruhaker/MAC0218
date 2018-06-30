require 'test_helper'

class SubjectTest < ActiveSupport::TestCase

    # Returns a random subject code
    def random_code
        return (0...3).map { (65 + rand(26)).chr }.join + (0...4).map { rand(9) }.join
    end

    def setup
        @present = Subject.new(
            code:          random_code,
            name:          Faker::Lorem.sentence,
            credits_class: rand(50),
            credits_work:  rand(50),
            workload:      rand(500),
            description:   Faker::Lorem.paragraph
        )
        @empty = Subject.new(
            code:          nil,
            name:          nil,
            credits_class: nil,
            credits_work:  nil,
            workload:      nil,
            description:   nil
        )
    end 
    
    test "should have code" do
        assert @present.code
    end

    test "should have name" do
        assert @present.name
    end

    test "should have credits_class" do
        assert @present.credits_class
    end

    test "should have credits_work" do
        assert @present.credits_work
    end

    test "should have workload" do
        assert @present.workload
    end

    test "should have description" do
        assert @present.description
    end

    test "should not have code" do
        assert_not @empty.code    
    end

    test "should not have name" do
        assert_not @empty.name    
    end
    
    test "should not have credits_class" do
        assert_not @empty.credits_class
    end
    
    test "should not have credits_work" do
        assert_not @empty.credits_work
    end
    
    test "should not have workload" do
        assert_not @empty.workload
    end

    test "should not have description" do
        assert_not @empty.description
    end

    test "credits_class should be integer" do
        assert @present.credits_class.is_a?(Integer)
    end

    test "credits_work should be integer" do
        assert @present.credits_work.is_a?(Integer)
    end

    test "workload should be integer" do
        assert @present.workload.is_a?(Integer)
    end
end
