class Customer < ApplicationRecord
  before_save :capitalize_first_letter

  has_many :carts

  private

  def capitalize_first_letter
    name.capitalize!
  end
  
end
