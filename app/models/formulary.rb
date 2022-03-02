class Formulary < ApplicationRecord
    validates :name, uniqueness: true
end
