class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :promotions
  has_many :promotion_approvals
  has_many :approved_promotions, through: :promotion_approvals, source: :promotion

  validate :email_domain
  IUGU_DOMAIN = 'iugu.com.br'

  def email_domain
    domain = email.split('@').last
    errors.add(:email, 'Domínio do email deve ser "@iugu.com.br"') if email.present? && domain != IUGU_DOMAIN
  end
end
