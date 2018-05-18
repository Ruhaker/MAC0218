class Group < ApplicationRecord
    
    validates :name, presence: {message: 'this field cannot be left black'}
    
    validates :min_credits, numericality: true, only_integer: true
  
    validates :min_subjects, numericality: true, only_integer: true
  
end
