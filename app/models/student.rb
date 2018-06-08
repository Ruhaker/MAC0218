class Student < User
    has_and_belongs_to_many :subjects, :through => :subject_students
    has_many :plans, :dependent => :destroy
    has_and_belongs_to_many :courses, :through => :plans, :join_table => :plans

    validates :nusp, numericality: true,
                        presence: {message: 'this field cannot be left black'},
                        format: {with: /[0-9]{1,8}/,
                                 message: 'is not a valid No. USP'},
                        uniqueness: {message: 'this No. USP already belongs to an user'}

    def to_s
      "Student: #{name} - #{nusp}"
    end
end

