require 'set'

class Cart < ApplicationRecord
  validates :customer_id, presence: true, numericality: { greater_than: 0 }

  belongs_to :customer
  has_many :cart_items

  def total
    total = 0
    items_array = []
    cart_items.includes(:medicine).each { |e| items_array.push([e.medicine.id, e.quantity, e.medicine.value]) }
    items_array = items_array.sort_by { |e| [e[1], e[2]] }.reverse
    grouped_items = group_items(items_array)
    discounts = [0, 1, 0.95, 0.9, 0.8, 0.75]
    grouped_items.each { |e| total += discounts[e[0].size] * e[1] }
    total
  end

  private

  def group_items(array)
    output = []
    array[0][1].times { output.push([[array[0][0]].to_set, array[0][2]]) }
    array.shift
    array, output, shift_counter = first_iteration(array, output)
    shift_counter.times { array.shift }
    array.each do |array_e|
      output.each_with_index do |output_e, output_i|
        if output_e[0].include?(array_e[0]) && output_i < output.size - 1
          output.push([[array_e[0].to_set, array_e[2]]])
          break
        elsif output_e[0].size == 3 && output[output_i - 1][0].size == 4
          possibility53 = (output[output_i - 1][1] + array_e[2]) * 0.75 + (output_e[1]) * 0.9
          possibility44 = (output_e[1] + array_e[2] + output[output_i - 1][1]) * 0.8
          if possibility44 > possibility53
            output[output_i - 1][0] << array_e[0]
            output[output_i - 1][1] += array_e[2]
            break
          else
            output_e[0] << array_e[0]
            output_e[1] += array_e[2]
            break
          end
        elsif output_e[0].size < 4 || (output_e[0].size == 4 && output.none? { |e| e[0].size < 4 })
          output_e[0] << array_e[0]
          output_e[1] += array_e[2]
          break
        end
      end
    end
    output
  end

  def first_iteration(array, output)
    shift_counter = 0
    array.each do |array_e|
      break if array_e[1] == 1

      output.each do |output_e|
        break if array_e[1].zero?
        next if output_e[0].include?(array_e[0])

        next unless output_e[0].size < 5

        output_e[0] << array_e[0]
        output_e[1] += array_e[2]
        array_e[1] -= 1
      end
      loop do
        break if array_e[1].zero?

        output.push([[array_e[0].to_set, array_e[2]]])
        array_e[1] -= 1
      end
      shift_counter += 1
    end
    [array, output, shift_counter]
  end
end
