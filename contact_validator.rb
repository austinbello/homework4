require 'csv'

class ContactValidator
  attr_reader :data
  def initialize(filename)
    @data = CSV.read(filename)
  end

  def true_false_array(column, regex)
    column_num = data[0].index(column)
    data.drop(1).map {|row| row[column_num].match(regex) != nil}
  end

  def validation_array
    checking_array = []

    checking_array << true_false_array("joined", /^([1][0-2]|[0]\d|\d)[\/-]([3][01]|[0-2]\d|\d)[\/-](\d{2}|\d{4})$/)
    checking_array << true_false_array("email", /^([\w\d_\-\.]+)@([\w\d_\-\.]+)\.([\w]{2,5})$/)
    checking_array << true_false_array("phone", /(^(\(([\d]{3})\)\s?|[^0]\d{2}(-|\s|\.))\d{3}(-|\s|\.)\d{4}$)|(^[^0]\d{9}$)/)

    checking_array_reorganized = []
    (0...(data.length-1)).each do |i|
      checking_array_reorganized << checking_array.map {|row| row[i]}
    end
    checking_array_reorganized
  end

  def true_count
    count = 0
    validation_array.each {|i| if i.all? {|j| j == true} == true
        count += 1
    end}
    count
  end

  def invalid_array
    false_array = []
    validation_array.each_with_index {|val, index| if val.all? {|j| j == true} != true
        val << index
        false_array << val
    end}
    false_array
  end

  def invalid_message(array)
    message = "Invalid "
    if array[0] == false
      if array[1] == false
        if array[2] == false
          message += "Date, Email, and Phone"
        else
          message += "Date and Email"
        end
      elsif array[2] == false
        message += "Date and Phone"
      else
        message += "Date"
      end
    elsif array[1] == false
      if array[2] == false
        message += "Email and Phone"
      else
        message += "Email"
      end
    elsif array[2] == false
      message += "Phone"
    end
  end

  def invalid_output
    invalid_array.each {|i| puts "Line #{i[3]+1}: #{invalid_message(i)}"}
  end
end

validator = ContactValidator.new('homework4.csv')
puts "Valid Lines: #{validator.true_count}"
puts ""
puts "Invalid Lines"
validator.invalid_output
