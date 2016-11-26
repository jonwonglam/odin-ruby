# EventManager.rb - Library to read and process csv files

require "csv"
require "sunlight/congress"
require "erb"

# Handle misformatted or missing zipcodes
def clean_zipcode(zipcode)
  zipcode.to_s.rjust(5, "0")[0..4]
end

# Use Sunlight lib to get list of legislators for a given zipcode
def legislators_by_zipcode(zipcode)
  legislators = Sunlight::Congress::Legislator.by_zipcode(zipcode)
end

# Write form to ouput/thanks_{id}.html
def save_thank_you_letters(id, form_letter)
  Dir.mkdir("output") unless Dir.exists? "output"

  filename = "output/thanks_#{id}.html"

  File.open(filename, 'w') { |file| file.puts form_letter }
end

# Read CSV file, convert the data into the ERB form, export to file
puts "EventManager Initialized!\n"

contents = CSV.open "event_attendees.csv", headers: true, header_converters: :symbol

template_letter = File.read "form_letter.erb"
erb_template = ERB.new template_letter

contents.each do |row|
  id = row[0]
  name = row[:first_name]

  zipcode = clean_zipcode(row[:zipcode])

  legislators = legislators_by_zipcode(zipcode)

  form_letter = erb_template.result(binding)

  save_thank_you_letters(id, form_letter)
end
