class Student < User
    has_many :subjects, :through => :subject_students
    has_many :course, :through => :plans
<<<<<<< HEAD

=======
=======
class Student < User
    
    validates :nusp, numericality: true, only_integer: true,
                        presence: {message: 'this field cannot be left black'},
                        format: {with: /[0-9]{7,8}/,
                                 message: 'is not a valid No. USP'},
                        uniqueness: {message: 'this No. USP already belongs to an user'}
    
>>>>>>> c71314fb0a529138718b22799cfce377bf1cbdb9
>>>>>>> a227c9b3af0d33069251ced3607f333271e0ebfc
end

