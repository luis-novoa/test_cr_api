class Medicine < ApplicationRecord
  before_save :capitalize_first_letter
  validates :name, presence: true, uniqueness: { case_sensitive: false }, length: { minimum: 2, maximum: 50 }
  validates :value, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :stock, presence: true, numericality: { greater_than_or_equal_to: 0 }

  def total
    value * quantity
  end
end
