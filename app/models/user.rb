class User < ApplicationRecord
    has_secure_password
  
    # Validations
    validates :username, presence: true, uniqueness: true
    validates :email, presence: true, uniqueness: true
    validates :password, length: { minimum: 6 }, if: -> { new_record? || !password.nil? }
  
    # Callback
    before_create :set_default_balance
  
    private
  
    def set_default_balance
      self.balance ||= 0.0
    end
    has_many :cards
  end
  