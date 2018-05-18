<<<<<<< HEAD
class Student < ApplicationRecord
    has_many :subjects, :through => :subject_students
    has_many :course, :through => :plans
=======
class Student < User
>>>>>>> c71314fb0a529138718b22799cfce377bf1cbdb9
end

