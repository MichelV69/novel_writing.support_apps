#! env ruby
require 'date'
require 'set'

seconds = 1
minutes = 60 * seconds
hours = 60 * minutes
days = 24 * hours
weeks = 7 * days

class Array
  def contains?(arguement)
    self.include?(arguement)
  end
end

def show_help()
  puts <<-HELPTEXT
  #How To Use This Applet#
  This applet supports three different use styles.

  You can have the tool randomly advance time to a reasonable "scene window" using the "+skip" syntax. A single "Skip" is between 11 and 44 minutes.

  `afterlivingFG.clocktick.rbx "<current story date and time>" "+skip" <how many skips>`

  + The applet will parse a writer/reader-friendly date and time string, such as "11:21am, Thursday, 12th June, 1997".
  + If an integer greater than 1 is supplied to the +skip command, then it will skip ahead that many times. So a supplied arguement of 3 means it will generate 3 different skip-ahead values and apply them.

  You can have the tool specifically advance time based on the duration of events in the story.

  `afterlivingFG.clocktick.rbx "<current story date and time>" "<event durations>" <+fuzz>`
  + <event durations> are notated like "3m" which would be "3 minutes", or perhaps "3h 2d 1m" which could be processed as "3 hours plus 2 days plus 1 minutes"
  + adding the optional +fuzz qualifier introduces an additional bit of random extra time to prevent human neatness instincts from producing times that look the same.

  HELPTEXT
  exit(0)
end

1.upto(2) do |required_arg|
  if ["", "help"].contains? ARGV[required_arg].to_s
    show_help
    end
  end

current_dtg = DateTime.parse(ARGV[0].to_s).to_time
increment_text_blob = ARGV[1].to_s

if increment_text_blob == "+skip"
  add_fuzz = true
  skip_toss = (ARGV[2].to_i > 0?ARGV[2].to_i : false) or 1

  increment_text_blob = ""
  1.upto(skip_toss) do
    skip = (Random.rand(11...44)).to_i
    increment_text_blob += "#{skip}m "
    end
  skip_toss_text = ""
  if skip_toss > 1
    skip_toss_text = "(#{skip_toss}x) "
    end
  puts "Skipping ahead #{skip_toss_text}#{increment_text_blob}"
  end

if ARGV[2].to_s == "+fuzz"
  add_fuzz = true
else
  add_fuzz = false
end

increment_text_set = increment_text_blob.chomp.split(" ")
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
