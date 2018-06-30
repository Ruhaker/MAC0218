class Group < ApplicationRecord
    belongs_to :course, optional: true
    has_many :groups, :dependent => :destroy
    belongs_to :group, optional: true
    has_many :group_indices, :dependent => :destroy
    has_many :subjects, :through => :group_indices
    has_one :plan

    validates :name, presence: {message: 'this field cannot be left black'}

    validates :min_credits, numericality: {only_integer: true, allow_nil: true}

    validates :min_subjects, numericality: {only_integer: true, allow_nil: true}

    # For easier debugging
    def to_s
        "Group: #{name} #{subjects.count}"
    end
end
