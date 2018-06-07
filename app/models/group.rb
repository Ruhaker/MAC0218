class Group < ApplicationRecord
    belongs_to :course, optional: true
    has_many :groups
    belongs_to :group, optional: true
    has_and_belongs_to_many :subjects
    has_one :plan

    validates :name, presence: {message: 'this field cannot be left black'}

    validates :min_credits, numericality: {only_integer: true, allow_nil: true}

    validates :min_subjects, numericality: {only_integer: true, allow_nil: true}

    # For easier debugging
    def to_s
        "Group: #{name} #{subjects.count}"
    end
end
