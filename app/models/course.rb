class Course < ApplicationRecord
  
    validates :name, presence: {message: 'this field cannot be left black'}
    
    validates :credits, numericality: true, only_integer: true,
                        presence: {message: 'this field cannot be left black'}
    
    validates :faculty, presence: {message: 'this field cannot be left black'}
    
    validates :expected_time, numericality: true, only_integer: true
  
end
