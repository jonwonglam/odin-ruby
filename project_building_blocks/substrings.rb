def substrings(input, dictionary)
  word_count = Hash.new(0)
  words = input.split(/\W+/)

  words.each do |word|
    dictionary.each do |substring|
      word_count[substring] += 1 if word.downcase.include? (substring)
    end
  end

  word_count
end

dictionary = ["below","down","go","going","horn","how","howdy","it","i","low","own","part","partner","sit"]
puts substrings("Howdy partner, sit down! How's it going?", dictionary)
