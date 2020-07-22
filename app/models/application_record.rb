class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  private

  def capitalize_first_letter
    name = self.name.split(' ')
    name.map!(&:capitalize)
    self.name = name.join(' ')
  end
end
