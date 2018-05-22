class Supervisor < User
    has_and_belongs_to_many :courses

    validates :cpf, numericality: {only_integer: true},
                        presence: {message: 'this field cannot be left black'},
                        format: {with: /[0-9]{10,13}/,
                                 message: 'is not a valid CPF, you should put just the numbers'},
                        uniqueness: {message: 'this CPF already belongs to an user'}

end
