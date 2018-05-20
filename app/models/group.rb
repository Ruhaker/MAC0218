class Group < ApplicationRecord
    belongs_to :course, optional: true
    has_many :groups
    has_and_belongs_to_many :subjects

    validates :name, presence: {message: 'this field cannot be left black'}

    validates :min_credits, numericality: {only_integer: true, allow_nil: true}

    validates :min_subjects, numericality: {only_integer: true, allow_nil: true}
end
