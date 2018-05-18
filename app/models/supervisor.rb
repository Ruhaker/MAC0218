<<<<<<< HEAD
class Supervisor < ApplicationRecord
    has_and_belongs_to_many :courses
=======
class Supervisor < User
    
    validates :cpf, numericality: true, only_integer: true,
                        presence: {message: 'this field cannot be left black'},
                        format: {with: /[0-9]{11}/,
                                 message: 'is not a valid CPF, you should put just the numbers'},
                        uniqueness: {message: 'this CPF already belongs to an user'}
    
>>>>>>> c71314fb0a529138718b22799cfce377bf1cbdb9
end
