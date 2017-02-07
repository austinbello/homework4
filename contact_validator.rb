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

    checking_array
  end
end
