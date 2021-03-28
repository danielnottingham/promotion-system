class Promotion < ApplicationRecord
  has_many :coupons, dependent: :destroy

  validates :name, :code, :discount_rate,
            :coupon_quantity, :expiration_date,
            presence: true

  validates :code, :name, uniqueness: true

  scope :search_by_name, ->(query) { where('name like ?', "%#{query}%") }

  def generate_coupons!
    return if coupons?

    (1..coupon_quantity).each do |number|
      coupons.create!(code: "#{code}-#{'%04d' % number}")
    end
  end

  # TODO: fazer testes pra esse método
  def coupons?
    coupons.any?
  end
end
