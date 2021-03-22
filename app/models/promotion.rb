class Promotion < ApplicationRecord
  has_many :coupons, dependent: :destroy

  validates :name, :code, :discount_rate,
            :coupon_quantity, :expiration_date,
            presence: { message: 'não pode ficar em branco' }

  validates :code, :name, uniqueness: { message: 'deve ser único' }
end
