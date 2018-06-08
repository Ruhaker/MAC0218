class Course < ApplicationRecord
    has_and_belongs_to_many :supervisors, :join_table => :supervises
    has_and_belongs_to_many :students, :through => :plans, :join_table => :plans
    has_one :group, :required => true, :dependent => :destroy
    has_many :plans, :dependent => :destroy

    validates :name, presence: {message: 'cannot be left blank'}

    validates :credits, numericality: {only_integer: true, message: 'must be an integer'},
                        presence: {message: 'cannot be left blank'}

    validates :teaching_unit, presence: {message: 'cannot be left blank'}

    validates :expected_time, numericality: {only_integer: true, message: 'must be an integer'}

    # For easier debugging
    def to_s
        "Course: #{name}"
    end
end
