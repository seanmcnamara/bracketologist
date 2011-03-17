!#/usr/bin/env ruby

require 'picker.rb'

puts [ARGV[0]]
a = [ARGV[0], ARGV[1]]


# Read in the ratings from Ken Pomeroy's Web site. A data entry avoidance technique,
# highly brittle. The result is a hash with the names of the schools as keys and
# a percentage chance of winning as the values. Percentages are versus an average
# team in Pomeroy's system.
$teams = {}
File.open("ratings2011.txt").each do |line|
  fields = line.split(",")

  team = fields[0]
  rating = fields[13]
  
  if team && rating
    if rating.to_f > 0
      $teams[team.rstrip] = rating.to_f
    end
  end
end

reduce(a)
