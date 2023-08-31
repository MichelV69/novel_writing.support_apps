#!/usr/bin/env ruby
# ----- time keeping in Soumerville story -----
# Last updated Wed 02-Aug-2017 @ 15h31 ADT by MichelV69

require "chronic"
require 'active_support/all'
require './wolflib.rb'

I18n.enforce_available_locales = false

# -----
# extend class Numeric to support time/distance measurements
class Numeric
  def kph
    self * 1000
  end #def kph

  def km
    self * 1000
  end #def km

  def percent_power(setting)
    self * (setting / 100.0)
  end
end # class Numeric

class PlotDevices
  def self.sometime_later(time)
    time
  end #def sometime_later

  def self.delay(time)
    time
  end #def delay

  def self.repairs(time)
    time
  end #def repairs
end # class PlotDevices

def time_passes(now, delta)
  new_time = now + delta

  time_has_passed = Array.new
  time_has_passed << new_time
  time_has_passed << delta / 1.0.hour

  return time_has_passed
end
# -----
# define constants
STORY_YEAR = 2253
STORY_START = "April 7th, #{STORY_YEAR} 02:23am"
TIME_FORMAT_STRING_SST = "%Hh%M SST, %A, %B %-dth, %Y" # ??h?? Standard Signal Time, Tuesday, April ??th
TIME_FORMAT_STRING_LCL = "%Hh%M Local"

# -----
# define arrays and hashes
speed    = Hash.new()
calendar = Hash.new()

# -----
# pre-load important variables
speed['land']    = 5.0.kph
speed['sub']     = 13.0.kph
speed['surface'] = 24.0.kph

# -----
# now start loading the calendar
calendar['ch1.title']     = 'Solitudes and Underseas'
calendar['ch1.Cordelia1'] = time_passes(Chronic.parse(STORY_START), 0.seconds)
calendar['ch1.Cordelia2'] = time_passes(calendar.last[1][0], 12.hours + 7.minutes)

calendar['ch2.title']     = 'Of Motors and Men'
calendar['ch2.Marlon1'] = time_passes(calendar['ch1.Cordelia2'][0], (243.km/speed['sub'].percent_power(80)).hours)
calendar['ch2.Cordelia1']  = time_passes(calendar.last[1][0], PlotDevices.repairs((0.75).hours))
calendar['ch2.Marlon2']  = time_passes(calendar.last[1][0], PlotDevices.repairs((6.03).hours))

calendar['ch3.title']     = 'Homecoming'
calendar['ch3.Cordelia1'] = time_passes(calendar['ch2.Marlon2'][0], (150.km/speed['sub'].percent_power(70)).hours)
calendar['ch3.Hal1'] = time_passes(calendar.last[1][0], (93.km/speed['sub'].percent_power(70)).hours)
calendar['ch3.Cordelia2'] = time_passes(calendar.last[1][0], PlotDevices.repairs((2.22).hours))

calendar['ch4.title'] = "Life at 80 Below"
calendar['ch4.Hal1'] = time_passes(calendar['ch3.Cordelia2'][0], PlotDevices.sometime_later(11.8).hours)
calendar['ch4.Cordelia1'] = time_passes(calendar.last[1][0], PlotDevices.sometime_later(2.9).hours)
calendar['ch4.Christopher1'] = time_passes(calendar.last[1][0], PlotDevices.sometime_later(1.7).hours)
calendar['ch4.Marlon1'] = time_passes(calendar.last[1][0],PlotDevices.sometime_later(26.65).hours)
calendar['ch4.Ise1'] = time_passes(calendar.last[1][0], PlotDevices.sometime_later(1.9).hours)
calendar['ch4.Jonas1'] = time_passes(calendar.last[1][0], PlotDevices.sometime_later(4.2).hours)

calendar['ch5.title'] = "Crystal Parlour Performance"

calendar['ch6.title'] = "To the Sea, Return"
calendar['ch6.Ise1'] = time_passes(calendar['ch4.Jonas1'][0], PlotDevices.sometime_later(6.4).days)
calendar['ch6.Hal1'] = time_passes(calendar.last[1][0], PlotDevices.sometime_later(7).minutes)
calendar['ch6.Cordellia1'] = time_passes(calendar.last[1][0], PlotDevices.sometime_later(97).minutes)

calendar['ch7.title']  = "Ready, Aye, Ready"
calendar['ch7.Jonas1'] = time_passes(calendar['ch6.Cordellia1'][0], PlotDevices.sometime_later(18.16).hours)
calendar['ch7.Jonas2'] = time_passes(calendar.last[1][0], PlotDevices.sometime_later(15).minutes)
calendar['ch7.Hal1']   = time_passes(calendar.last[1][0], PlotDevices.sometime_later(10.4).hours)
calendar['ch7.Damiano1']   = time_passes(calendar.last[1][0], PlotDevices.sometime_later(10).minutes)
calendar['ch7.Cordellia1'] = time_passes(calendar.last[1][0], PlotDevices.sometime_later(20).minutes)
calendar['ch7.Kimberly1']  = time_passes(calendar.last[1][0], PlotDevices.sometime_later(6.5).hours)

calendar['ch8.title'] = "Dearly Departing"
calendar['ch8.Hal1']  = time_passes(calendar['ch7.Kimberly1'][0], PlotDevices.sometime_later(7.22).hours)
calendar['ch8.Marlon1'] = time_passes(calendar.last[1][0],PlotDevices.sometime_later(1.1).hours)
calendar['ch8.Ise1']    = time_passes(calendar.last[1][0],PlotDevices.sometime_later(1.25).hours)
calendar['ch8.Cordellia1'] = time_passes(calendar.last[1][0],PlotDevices.sometime_later(0.9).hours)
calendar['ch8.Jonas1'] = time_passes(calendar.last[1][0],PlotDevices.sometime_later(0.8).hours)
calendar['ch8.Alodia1'] = time_passes(calendar.last[1][0],PlotDevices.sometime_later(0.1).hours)

calendar['ch9.title'] = "Hearing Ghosts"
rv_lanier   =  750.km
point_ghost = 1313.km
old_boston  = 1730.km
lanier_late = 6.hours
ras_time    = 2.hours

calendar['ch9.RV_Lanier1'] = time_passes(calendar['ch8.Alodia1'][0], (rv_lanier/speed['sub'].percent_power(80)).hours)
calendar['ch9.RV_Lanier2'] = time_passes(calendar.last[1][0], PlotDevices.delay(lanier_late) + PlotDevices.delay(ras_time))
calendar['ch9.Jonas1'] = time_passes(calendar.last[1][0], ((point_ghost - rv_lanier)/speed['sub'].percent_power(80)).hours)
calendar['ch9.Cordellia1'] = time_passes(calendar.last[1][0],PlotDevices.sometime_later(0.1).hours)
calendar['ch9.Hal1'] = time_passes(calendar.last[1][0],PlotDevices.sometime_later(1.1).hours)
calendar['ch9.Christopher1'] = time_passes(calendar.last[1][0],PlotDevices.sometime_later(8.04).hours)
elapsed_story_time = (0.1 + 1.1 + 8.04).hours
hours_to_travel = ((old_boston - point_ghost)/speed['surface'].percent_power(80)).hours
hours_left_to_travel = hours_to_travel - elapsed_story_time
calendar['ch9.Boston'] = time_passes(calendar.last[1][0], hours_left_to_travel)


# -----
# now put it out on the screen nicely formated
puts " ----- Time Line for Soumerville: Steampunk #{STORY_YEAR} -----"
calendar.each_pair { |event, details|

  if event.include? 'title'
    title_string = "#{event} #{details}"
    puts "\n #{title_string}"

    underline = '``'
    1.upto(title_string.length) { underline += "`"}
    puts underline
  else
    puts " #{event} => " + "#{details[1].hours_to_human} later ... " + details[0].strftime(TIME_FORMAT_STRING_SST) + " / " + (details[0] -4.hours).strftime(TIME_FORMAT_STRING_LCL)
  end

}
puts "\n\n ----- end of output -----"
# ----- end of file -----
