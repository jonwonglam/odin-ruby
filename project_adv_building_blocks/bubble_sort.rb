def bubble_sort(array)
  (1...array.length).each do |iteration|
    (0...array.length - iteration).each do |index|
      if array[index] > array[index + 1]
        array[index], array[index + 1] = array[index + 1], array[index]
      end
    end
  end
  array
end

def bubble_sort_by(array)
  (1...array.length).each do |iteration|
    (0...array.length - iteration).each do |index|
      if yield(array[index], array[index + 1])
        array[index], array[index + 1] = array[index + 1], array[index]
      end
    end
  end
  array
end

my_array = [4, 3, 78, 2, 0, 2]
puts "Before: [#{my_array.join(', ')}]"
puts "After: [#{bubble_sort(my_array).join(', ')}]"

my_array = ["hey", "hello", "hi", "bleh"]
puts "Before: [#{my_array.join(', ')}]"
my_array = bubble_sort_by(my_array) {|left, right| left.length > right.length}
puts "After: [#{my_array.join(', ')}]"
