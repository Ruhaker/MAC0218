class Course < ApplicationRecord
    has_and_belongs_to_many :supervisors
    belongs_to :group
    has_many :students, :through => :plans
end
