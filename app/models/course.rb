class Course < ApplicationRecord
    has_and_belongs_to_many :supervisors, :join_table => :supervises
    has_one :group, required: true, :dependent => :destroy
    has_many :plans, :dependent => :destroy
    has_and_belongs_to_many :students, :through => :plans, :join_table => :plans

    validates :name, presence: {message: 'cannot be left blank'}

    validates :credits, numericality: {only_integer: true, message: 'must be an integer'},
                        presence: {message: 'cannot be left blank'}

    validates :teaching_unit, presence: {message: 'cannot be left blank'}

    validates :expected_time, numericality: {only_integer: true, message: 'must be an integer'}

    # Do these things after initialization
    after_initialize :create_group

    # Automagically creates required associated group
    def create_group
        assign_attributes({
                :group => Group.create({
                :name         => "Grade",
                :min_credits  => nil,
                :min_subjects => nil
            })
        })
    end

    # For easier debugging
    def to_s
        "Course: #{name}"
    end
end
