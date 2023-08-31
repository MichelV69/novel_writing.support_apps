#! env ruby
require 'date'
require 'set'

seconds = 1
minutes = 60 * seconds
hours = 60 * minutes
days = 24 * hours
weeks = 7 * days

current_dtg = DateTime.parse(ARGV[0].to_s).to_time
increment_text_blob = ARGV[1].to_s

if ARGV[2].to_s == "+fuzz"
  add_fuzz = true
else
  add_fuzz = false
end

if increment_text_blob == "+skip"
  add_fuzz = true
  skip = (Random.rand(11...33)).to_i
  increment_text_blob = "#{skip}m"
  puts "Skipping ahead " + increment_text_blob
end

increment_text_set = increment_text_blob.split(" ")
updated_time = current_dtg

increment_text_set.each { |request|
  increment_amount = request[0..request.length-1].to_i
  increment_unit = request[-1]

  time_change = case increment_unit
    when "m"
      increment_amount * minutes
    when "h"
      increment_amount * hours
    when "d"
      increment_amount * days
    when "w"
      increment_amount * weeks
  end

  if add_fuzz
    fuzz = (Random.rand(11...22)/100.0 * time_change.to_f).to_i
    phrase = "#{fuzz/minutes} minutes"
    phrase = "a few seconds" if (fuzz/minutes) < 1.0
    puts "(adding #{phrase} of 'fuzz')"
    time_change = time_change + fuzz
  end
  updated_time = updated_time + time_change
  }

date_suffix = case updated_time.to_date.mday.to_s[-1]
  when "1"
    "st"
  when "2"
    "nd"
  when "3"
    "rd"
  else
    "th"
end

date_exceptions = Set[11, 12, 13]
if date_exceptions.include? updated_time.to_date.mday
  date_suffix = "th"
end

book_time_string = "%l:%M%P, %A, %-d#{date_suffix} %B, %Y"
puts updated_time.strftime(book_time_string)
