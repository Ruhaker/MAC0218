class Plan < ApplicationRecord
    belongs_to :course
    belongs_to :student
    belongs_to :group
    
    # Do these things after initialization
    after_initialize :create_group

    # Automagically creates required associated group
    def create_group
        assign_attributes({
                :group => Group.create({
                :name         => "Pessoal",
                :min_credits  => nil,
                :min_subjects => nil
            })
        })
    end
end
