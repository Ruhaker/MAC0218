class Plan < ApplicationRecord
    belongs_to :course
    belongs_to :student
    belongs_to :group
end
