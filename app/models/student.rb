class Student < ApplicationRecord
    has_many :subjects, :through => :subject_students
    has_many :course, :through => :plans
end

