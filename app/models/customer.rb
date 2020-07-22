class Customer < ApplicationRecord
  before_save :capitalize_first_letter

  validates :name, presence: true, uniqueness: { case_sensitive: false }, length: { minimum: 2, maximum: 50 }

  has_many :carts
  private
  
end
