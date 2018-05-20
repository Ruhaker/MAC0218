class Student < User
    has_many :subjects, :through => :subject_students
    has_many :course, :through => :plans

    validates :nusp, numericality: true,
                        presence: {message: 'this field cannot be left black'},
                        format: {with: /[0-9]{6,8}/,
                                 message: 'is not a valid No. USP'},
                        uniqueness: {message: 'this No. USP already belongs to an user'}
end

