class User < ApplicationRecord

    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

    validates :name, :email, :cpf, presence: true
    validates :cpf, length: { is: 11 }
    validates :cpf, uniqueness: true
    validates :email, format: { with: VALID_EMAIL_REGEX }
    validates :email, uniqueness: true
end
