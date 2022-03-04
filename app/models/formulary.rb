class Formulary < ApplicationRecord
    validates :name, uniqueness: true

    has_many :questions
    has_many :answer
end
