class CartItem < ApplicationRecord
  validates :cart_id, presence: true, numericality: { greater_than: 0 }
  validates :medicine_id, presence: true, uniqueness: true, numericality: { greater_than: 0 }
  validates :quantity, presence: true, numericality: { greater_than: 0 }

  belongs_to :cart
  belongs_to :medicine
end
