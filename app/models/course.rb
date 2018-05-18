class Course < ApplicationRecord
<<<<<<< HEAD
    has_and_belongs_to_many :supervisors
    belongs_to :group
    has_many :students, :through => :plans
=======
  
    validates :name, presence: {message: 'this field cannot be left black'}
    
    validates :credits, numericality: true, only_integer: true,
                        presence: {message: 'this field cannot be left black'}
    
    validates :faculty, presence: {message: 'this field cannot be left black'}
    
    validates :expected_time, numericality: true, only_integer: true
  
>>>>>>> c71314fb0a529138718b22799cfce377bf1cbdb9
end
