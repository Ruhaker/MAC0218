class Subject < ApplicationRecord
    has_and_belongs_to_many :groups
    has_and_belongs_to_many :students
    has_and_belongs_to_many :subjects
    has_many :students, :through => :subject_students
end
