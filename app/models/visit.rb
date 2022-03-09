class Visit < ApplicationRecord
    acts_as_paranoid

    validates :date, :status, :checkin_at, :checkout_at, :user_id, presence: true
    validates :status, inclusion: { in: ['pendente', 'realizando', 'realizado'],
                                    message: "%{value} is not a valid option for status"}
    validate :date_before_current_date, :checkin_at_validation, :checkout_at_validation
    
    belongs_to :user
    has_many :answer, dependent: :destroy

    private
    def date_before_current_date
        if date.present? && date < Date.today
            errors.add(:date, "can't be in the past")
        end
    end
    def checkin_at_validation
        if date.present? && checkin_at.present? && checkin_at >= date
            errors.add(:checkin_at, "checkin_at cant be after current day")
        end
    end
    def checkout_at_validation
        if checkout_at.present? && checkin_at.present? && checkout_at < checkin_at
            errors.add(:checkout_at, "cant be before chekin_at")
        end
    end      
end
