module Enumerable
  def my_each
    for element in self do
      yield(element)
    end
    self
  end

  def my_each_with_index
    index = 0
    for element in self do
      yield(element, index)
      index += 1
    end
    self
  end

  def my_select
    array = []
    self.my_each {|element| array << element if yield(element)}
    array
  end

  def my_all
    self.my_each {|element| return false if !yield(element)}
    return true
  end

  def my_any
    self.my_each {|element| return true if yield(element)}
    return false
  end

  def my_map(proc = nil)
    result = []
    if proc && block_given?
      self.my_each {|element| result << proc.call(yield(element))}
    elsif proc && !block_given?
      self.my_each {|element| result << proc.call(element)}
    elsif proc.nil? && block_given?
      self.my_each {|element| result << yield(element)}
    else
      self
    end
    result
  end

  def my_inject(startingValue)
    accumulator = startingValue
    self.my_each {|element| accumulator = yield(accumulator, element)}
    accumulator
  end

end

my_array = [2, 3, 5, 29]

# my_each test
my_array.my_each do |element|
  print "#{element}, "
end
puts

# my_each_with_index test
my_array.my_each_with_index do |element, index|
  print "#{element}: index #{index}, "
end
puts

# my_select test
print my_array.my_select {|element| element < 6}
puts

# my_all test
print "Are all elements < 6? #{my_array.my_all {|element| element < 6}}"
puts
print "Are all elements < 30? #{my_array.my_all {|element| element < 30}}"
puts

# my_any test
print "Are any elements > 6? #{my_array.my_any {|element| element > 6}}"
puts
print "Are any elements > 30? #{my_array.my_all {|element| element > 30}}"
puts

# my_map test with block
print "My_map test: Double elements: #{my_array.my_map {|element| element * 2 }}"
puts

# my_inject test
def multiply_els(array)
  array.my_inject(1) {|result, element| result * element}
end

print "My_inject test: multiples of all the elements in #{my_array} is #{multiply_els(my_array)}"
