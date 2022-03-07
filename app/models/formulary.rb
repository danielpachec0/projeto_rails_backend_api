class Formulary < ApplicationRecord
    acts_as_paranoid

    validates :name, uniqueness: true

    has_many :questions, dependent: :destroy
    has_many :answer, dependent: :destroy
end
