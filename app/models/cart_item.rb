class CartItem < ApplicationRecord
  validates :cart_id, presence: true, numericality: { greater_than: 0 }
  validates :medicine_id, presence: true, numericality: { greater_than: 0 }

  belongs_to :cart
  belongs_to :medicine
end
