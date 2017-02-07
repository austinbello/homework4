require 'csv'

class ContactValidator
  attr_reader :data
  def initialize(filename)
    @data = CSV.read(filename)
  end

  def get_numbers
    data.flatten.select {|s| s.match(/\d{3}-\d{3}-\d{4}/)}
  end

  def true_false_array(column, regex)
    column_num = data[0].index(column)
    data.drop(1).map {|row| row[column_num].match(regex) != nil}
  end
end
