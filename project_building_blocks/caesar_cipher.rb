def caesar_cipher(sentence, offset)
  letters_lower = ('a'..'z').to_a
  letters_upper = ('A'..'Z').to_a
  encrypted = ""

  sentence.each_char do |c|
    if c.match(/[a-z]/)
      encrypted += letters_lower[(letters_lower.index(c) + offset) % 25]
    elsif c.match(/[A-Z]/)
      encrypted += letters_upper[(letters_upper.index(c) + offset) % 26]
    else
      encrypted += c
    end
  end

  puts encrypted
end

caesar_cipher("What a string!", 5)
