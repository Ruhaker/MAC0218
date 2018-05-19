class Group < ApplicationRecord
#<<<<<<< HEAD
    belongs_to :course
    has_many :groups
    has_and_belongs_to_many :subjects
#=======

    validates :name, presence: {message: 'this field cannot be left black'}

    validates :min_credits, numericality: {only_integer: true}

    validates :min_subjects, numericality: {only_integer: true}

#>>>>>>> c71314fb0a529138718b22799cfce377bf1cbdb9
end
