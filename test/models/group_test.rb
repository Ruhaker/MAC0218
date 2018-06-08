require 'test_helper'

class GroupTest < ActiveSupport::TestCase
    def setup
        @group = Group.new({
            :name         => "Grupo MAE",
            :min_credits  => nil,
            :min_subjects => 1
        })

        @group.save
    end

    test "group_subject relationship" do
        @estat = Subject.find_by!(:name => "Estatística Descritiva")
        @prob = Subject.find_by!(:name => "Probabilidade 1")
        @map = Subject.find_by!(:name => "Matemática, Design e Arquitetura")
        @group = Group.find_by!(:name => "Grupo MAE")
        @group.subjects << @estat
        @group.subjects << @prob

        @group.subjects.each do |subject|
            assert @group.subjects.exists?(subject.id) , "#{subject.to_s} should be a subject of #{@group.to_s}"
        end
        assert     @group.subjects[1].valid?, "'#{@prob.name} should be a valid subject"
        assert_not @group.subjects.exists?(@map.id), "'#{@map.name} should not be a subject of #{@group.name}"

    end

    test "group_group relationship" do
        @group = Group.find_by!(:name => "Grupo MAE")
        @sub_group = Group.find_by!(:name => "Opt. de Estatística")
        @group.groups << @sub_group

        assert @group.groups.exists?(@sub_group.id), "#{@sub_group.name} nao sei"
    end

    test "should be valid" do
        assert @group.valid?, "#{@group.errors.first}"
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
