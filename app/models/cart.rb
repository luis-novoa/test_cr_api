class Cart < ApplicationRecord
  validates :customer_id, presence: true, numericality: { greater_than: 0 }

  belongs_to :customer
  has_many :cart_items

  def total
    total = 0
    cart_items.includes(:medicine).each { |e| total += e.quantity * e.medicine.value }
    total
  end
end
