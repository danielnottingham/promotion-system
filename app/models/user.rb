class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validate :email_domain
  IUGU_DOMAIN = 'iugu.com.br'

  def email_domain
    domain = email.split('@').last
    errors.add(:email) if email.present? && domain != IUGU_DOMAIN
  end
end
