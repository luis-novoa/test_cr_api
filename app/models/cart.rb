class Cart < ApplicationRecord
  validates :customer_id, presence: true, numericality: { greater_than: 0 }

  belongs_to :customer
  has_many :cart_items
end
