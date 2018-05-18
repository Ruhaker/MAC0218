class Group < ApplicationRecord
    belongs_to :course
    has_many :groups
    has_and_belongs_to_many :subjects
end
