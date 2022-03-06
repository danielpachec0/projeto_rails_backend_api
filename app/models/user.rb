class User < ApplicationRecord
    has_secure_password

    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
    VALID_CPF_REGEX = /(\d{3}\.\d{3}\.\d{3}\-\d{2})/
    VALID_PASSWORD_REGEX = /[a-zA]+\d+/

    validates :name, :email, :cpf, presence: true
    validates :cpf, format: { with: VALID_CPF_REGEX }
    validates :email, format: { with: VALID_EMAIL_REGEX }
    validates :email, uniqueness: true
    validate :check_cpf
    validates :cpf, uniqueness: true
    validates :password, length: { minimum: 6 } 
    validates :password, format: { with: VALID_PASSWORD_REGEX }

    has_many :visits, dependent: :destroy

    private
      
    def check_cpf
        if cpf.nil? 
            errors.add(:cpf, "is not valid")
            return
        else
            cpf_mod = cpf.tr('.', '')
            cpf_mod = cpf_mod.tr('-', '')
        end
        if cpf_mod.length != 11 
            errors.add(:cpf, "is not valid")
            return
        end

        equal = true
        (1..10).step do |i|
            if cpf_mod[i] != cpf_mod[i-1]
                equal =  false
                break
            end
        end
    
        if equal == true 
             errors.add(:cpf, "invalid cpf")
             return
        end
    
        y = []
    
        cpf_mod.each_char do |char| 
            y.push char.to_i 
        end 
    
        sum1 = 0
        sum2 = 0
        (0..9).step do |i|
            unless i == 9
                sum1 = sum1 + (y[i] * (10-i))
            end
            sum2 = sum2 + (y[i] * (11-i))
        end 
        mod1 = (sum1 * 10)%11
        if mod1 == 10 then mod1 = 0 end
        mod2 = (sum2 * 10)%11
        if mod2 == 10 then mod2 = 0 end
        if !(mod1 == y[9] && mod2 == y[10])
            errors.add(:cpf, "is not valid")
            return
        end
    end
end
