class Subject < ApplicationRecord

    has_and_belongs_to_many :groups
    has_and_belongs_to_many :students
    has_and_belongs_to_many :subjects
    has_many :students, :through => :subject_students

    validates :code, presence: {message: 'this field cannot be left black'},
                       format: {with: /[A-Z]{3}[0-9]{4}/,
                                message: 'is not a valid subject code, it should be like ´MAC0110`'}

    validates :name, presence: {message: 'this field cannot be left black'}

    validates :credits_class, numericality: {only_integer: true},
                        presence: {message: 'this field cannot be left black'}

    validates :credits_work, numericality: {only_integer: true}
end
