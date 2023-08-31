# ---------------------------------------------------- #
# Last updated Wed 18-Oct-2017 @ 00h51 ADT by MichelV69
# ---------------------------------------------------- #

# ---------------------------------------------------- #
class ShipWatches

=begin

example use:

  info = sheerah.on_watch(hour_of_day, hours_since_start, watch_conditions)
  watch_name   = sheerah.watch_times[info['watch_id']]['name']
  officer_name = sheerah.officer_list[watch_conditions][info['officer_id']]
  printf "[%s (+)] %s Watch Officer(s): %s \n", hour_of_day, watch_name, officer_name

  require './wolflib.rb'
  sheerah = ShipWatches.new
  sheerah.officer_list['standard'] = ["Ise", "Jonas", "Cordelia", "Marlon", "Christopher", "Damiano"]
  sheerah.officer_list['combat']   = ["Ise & Jonas", "Cordelia & Marlon", "Christopher & Damiano"]

  hour_of_day=1
  hours_since_start=49
  watch_conditions='combat'


=end

  attr_accessor :officer_list
  attr_accessor :watch_times

  # ---
  def initialize()
    self.officer_list = Hash.new
    self.watch_times = Hash.new

    # ---
    self.officer_list['standard'] = Array.new
    self.officer_list['combat']   = Array.new

    # ---
    self.watch_times[0] = {'name' => 'Middle',    "start" => '00', "finish" => '03'}
    self.watch_times[1] = {'name' => 'Morning',   "start" => '04', "finish" => '07'}
    self.watch_times[2] = {'name' => 'Forenoon',  "start" => '08', "finish" => '11'}
    self.watch_times[3] = {'name' => 'Afternoon', "start" => '12', "finish" => '15'}
    self.watch_times[4] = {'name' => 'First Dog', "start" => '16', "finish" => '17'}
    self.watch_times[5] = {'name' => 'Last Dog',  "start" => '18', "finish" => '19'}
    self.watch_times[6] = {'name' => 'First',     "start" => '20', "finish" => '23'}

  end # def initialize

  def watches_per_day
    self.watch_times.count
  end # watches_per_day

  # ---
  def on_watch(hour_of_day, hours_since_start, watch_conditions)

    # - figure out which watch it is, based on hour_of_day
    # - pick that data from naval watch system
    watch_pointer = 0
    officer_pointer = 0
    loop_index = 0

    self.watch_times.each do |loop_index, watch_data|
      start  = watch_data['start'].to_i
      finish = watch_data['finish'].to_i
      if ((start <= hour_of_day) &&
         (hour_of_day <= finish))
          watch_pointer = loop_index
      end
    end

    # - figure out how many watches have gone by, based of hours_since_last_watch
    # - pick that officer(s) from the officer rotation list
    elapsed_days = hours_since_start / 24
    rotations_per_day = self.watches_per_day / self.officer_list[watch_conditions].count
    single_rotation_period_days = self.watches_per_day * self.officer_list[watch_conditions].count
    watches_to_account_for = (elapsed_days % single_rotation_period_days) * self.watches_per_day
    watch_offset = watches_to_account_for % (rotations_per_day.round() * self.officer_list[watch_conditions].count)

    officer_pointer = (watch_pointer + watch_offset) % officer_list[watch_conditions].count

    # - now return the pointer data
    return {'officer_id' => officer_pointer, 'watch_id' => watch_pointer}

  end #def on_watch

end #class shipWatch

# ---------------------------------------------------- #
class Hash
  def last
    last = self.count
    last_key = self.keys[last -1]
    product = Array.new
    product << last_key << self[last_key]
    return product
  end
end # class Hash

# ---------------------------------------------------- #
class Numeric
  def hours_to_human
    mm = (self * 60).round()  # because we might get a number like 43.21 hours
    hh, mm = mm.divmod(60)           #=> [43, 13]
    dd, hh = hh.divmod(24)           #=> [1, 19]

    human_string = ""
    if dd > 0
      human_string +=  " %d days" % [dd]
    end
    if hh > 0
      human_string +=  " %d hours" % [hh]
    end
    if mm > 0
      human_string +=  " %d minutes" % [mm]
    end

    return human_string             #=> "1 days 19 hours 12 minutes"
  end # def hours_to_human
end # class Numeric

# ---------------------------------------------------- #
require 'enumerator'
def commify(num)
   str =  num.to_s
   a = []
   str.split(//).reverse.each_slice(3) { |slice| a << slice }
   new_a = []
   a.each do |item|
     new_a << item
     new_a << [","]
   end
   new_a.delete_at(new_a.length - 1)
   new_a.flatten.reverse.join
end

# ---------------------------------------------------- #
def leastof(first, second)

	if first < second then
		return first
	else
		return second
	end # if first, second
end # def leastof(first, second)

# ---------------------------------------------------- #
def mostof(first, second)

	if first > second then
		return first
	else
		return second
	end # if first, second
end # def leastof(first, second)

# ---------------------------------------------------- #
class Fixnum
  def billion
    self * 1000000000
  end # def billion
end # class Fixnum

# ---------------------------------------------------- #
class Fixnum
  def d10
    workTotal=0
    1.upto(self) do |dicePtr|
      workTotal += rand(10)+1
      end # do
    return workTotal
  end # def d10
end # class Fixnum

# ---------------------------------------------------- #
class Fixnum
  def d8
    workTotal=0
    1.upto(self) do |dicePtr|
      workTotal += rand(8)+1
      end # do
    return workTotal
  end # def d8
end # class Fixnum

# ---------------------------------------------------- #
class Fixnum
  def d6
    workTotal=0
    1.upto(self) do |dicePtr|
      workTotal += rand(6)+1
      end # do
    return workTotal
  end # def d6
end # class Fixnum

# ---------------------------------------------------- #
class Fixnum
  def d100
    workTotal=0
    1.upto(self) do |dicePtr|
      workTotal += rand(100)+1
      end # do
    return workTotal
  end # def d100
end # class Fixnum

# ---------------------------------------------------- #
class Fixnum
  def million
    self * 1000000
  end # def billion
end # class Fixnum

# ---------------------------------------------------- #
class Fixnum
  def percent
    (self / 100).to_f
  end # def percent
end # class Fixnum

# ---------------------------------------------------- #
def signi2(to_round)
  up_value = to_round.to_f*100.00
  round_value = up_value.round
  down_value = round_value/100.00
  return down_value.to_f
end

# ---------------------------------------------------- #

def hexmap_distance(from_hex, to_hex)
	from_hex_cols = (from_hex.to_i / 100).to_i
	from_hex_rows = from_hex.to_i - from_hex_cols * 100

	to_hex_cols = (to_hex.to_i / 100).to_i
	to_hex_rows = to_hex.to_i - to_hex_cols * 100

	m = (from_hex_cols - to_hex_cols).abs
	n = (from_hex_rows - to_hex_rows).abs

	dist = (Math.sqrt((m+n)**2 - m*n)).to_int

	if dist > 6 then
		dist = dist -1
		end

	return dist
end

# ---------------------------------------------------- #
	def read_tsv_file(tsv_file)
	    #5:15 PM 9/13/2007
		tsv_records = Array.new

		File.open(tsv_file, "r") do |readAndProcess|
		  # ... process the file

			readAndProcess.each_line {|line| workText = line.chomp
				beforeREM, afterREM = workText.split(';')
		# -- Begin Main logic
				if not beforeREM.to_s.empty?
					tsv_records << beforeREM
					end # if not beforeREM.to_s.empty?
		# -- End Main logic

				putc('#')
		  	} # readAndProcess.each_line

			puts('')
		end # File.open("speed_dials.csv", "r") do |readAndProcess|

		return tsv_records

	end # read_tsv_file

# ---------------------------------------------------- #

class Fixnum
	def hex
		case self
			when 10 then return "A"
			when 11 then return "B"
			when 12 then return "C"
			when 13 then return "D"
			when 14 then return "E"
			when 15 then return "F"
			when 16 then return "G"
			when 17 then return "H"
			default
				return self
		end # case self
	end # def hex

end # class String

# ---------------------------------------------------- #
