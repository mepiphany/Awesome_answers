class User < ActiveRecord::Base
  has_many :questions, dependent: :nullify
  has_many :answers, dependent: :nullify
  # attr_accessor :password
  # attr_accessor :password_confirmation

  # more info about has_secure_password can be found here:
  # http://api.rubyonrails.org/classes/ActiveModel/SecurePassword/ClassMethods.html
  has_secure_password

  validates :password, length: {minimum: 6}, on: :create
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true,
                    uniqueness: true,
                    format: /\A([\w+\-]\.?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i



 def full_name
   "#{first_name} #{last_name}".titleize #<<< this will capitalize everything inside your string
 end


end
