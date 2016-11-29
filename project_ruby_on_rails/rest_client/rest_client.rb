require 'rest-client'

query = 'test'
response = RestClient.get "http://google.com/#q=#{query}"

puts "Code: #{response.code}"
puts "Cookies: #{response.cookies}"
