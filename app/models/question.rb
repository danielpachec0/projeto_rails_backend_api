class Question < ApplicationRecord
    validates :name, uniqueness: {  scope: :formulary_id,
                                    message: "uniquennes msg placeholder"}

    belongs_to :formulary
end
