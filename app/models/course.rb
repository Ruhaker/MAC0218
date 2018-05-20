class Course < ApplicationRecord
    has_and_belongs_to_many :supervisors
    has_one :group
    has_many :students, :through => :plans

    validates :name, presence: {message: 'cannot be left blank'}

    validates :credits, numericality: {only_integer: true, message: 'must be an integer'},
                        presence: {message: 'cannot be left blank'}

    validates :teaching_unit, presence: {message: 'cannot be left blank'}

    validates :expected_time, numericality: {only_integer: true, message: 'must be an integer'}
end
