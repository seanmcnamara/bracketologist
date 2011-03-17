!#/usr/bin/env ruby

# Applies the log5 formula to determine the odds of one team beating another.
def log5(a, b)
  return a*(1 - b)/(a*(1 - b) + (1 - a)*b)
end

def check_team(team)
  puts team
  exists = "does not exist"
  if $teams.has_key?(team)
    exists = "exists"
  end
  puts team + " " + exists
end

# Accepts an array of teams in the order of their seeding (so that the matchups)
# work. Returns an array of the winning teams from the matchup. So for the first
# round, it takes 16 teams and returns the 8 winners. It figures out the odds of 
# each team winning and determines a winner based on the random number generator.
def reduce(bracket)
  winners = []
  
  (0 .. ((bracket.length()/2) - 1)).each do |index|
    opponent_a = bracket[index]
    opponent_b = bracket[bracket.length - index - 1]
    
    #check_team(opponent_a)
    #check_team(opponent_b)
    
    winning_pct_for_a = log5($teams[opponent_a], $teams[opponent_b])
  
    puts opponent_a + " has a " + (winning_pct_for_a * 100).round().to_s + "% chance of beating " + opponent_b
  
    if rand() > winning_pct_for_a 
      puts "Winner: " + opponent_b + "\n\n"
      winners << opponent_b 
    else
      puts "Winner: " + opponent_a + "\n\n"
      winners << opponent_a 
    end
  end
  
  return winners
end

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

# Must be in order of seeding. Names must match the keys in $teams

# WEST
# (1) Duke Blue Devils vs. (16) Hampton Pirates
# (8) – Michigan Wolverines vs. (9)Tennessee Volunteers
#
# (4) Arizona Wildcats vs. (13) Memphis Tigers
# (5) Texas Longhorns vs. (12)Oakland Golden Grizzlies
#
# (3) UConn Huskies vs. (14) Bucknell Bison
# (6) Cincinnati Bearcats vs. (11) Missouri Tigers
#
# (7) Temple Owls vs. (10) Penn State Nittany Lions
# (2) San Diego State Aztecs vs. (15) Northern Colorado Bears
west = ["Duke", "San Diego St.", "Connecticut", "Arizona", "Texas", "Cincinnati", "Temple",
  "Michigan", "Tennessee", "Penn St.", "Missouri", "Oakland", "Memphis", "Bucknell",
  "Northern Colorado", "Hampton"]
  
#  EAST
#  (1) Ohio State Buckeyes vs. (16) Texas-San Antonio/Alabama State
#  (8) George Mason Patriots vs. (9) Villanova Wildcats
#
#  (4) West Virginia Mountaineers vs. (13) UAB/Clemson
#  (5) Kentucky Wildcats vs. (12) Princeton Tigers
#
#  (6) Xavier Musketeers vs. (11) Marquette Golden Eagles
#  (3) Syracuse Orange vs. (14) Indiana State Sycamores
#
#  (7) Washington Huskies vs. (10) Georgia Bulldogs
#  (2) North Carolina Tarheels vs. (15) Long Island University Blackbirds
east = ["Ohio St.", "North Carolina", "Syracuse", "West Virginia", "Kentucky", "Xavier", "Washington", 
  "George Mason",  "Villanova", "Georgia", "Marquette", "Princeton", reduce(["UAB","Clemson"])[0], 
  "Indiana St.", "Long Island", reduce(["Texas San Antonio", "Alabama St."])[0]]

# SOUTHWEST
#  (1) Kansas Jayhawks vs. (16) Boston University Terriers
#  (8) UNLV Runnin Rebels vs. (9) Illinois Fightin Illini
#
#  (4) Louisville Cardinals vs. (13) Morehead State Eagles
#  (5) Vanderbilt Commodores vs. (12) Richmond Spiders
#
#  (3) Purdue Boilermakers vs. (14) Saint Peter’s Peacocks
#  (6) Georgetown Hoyas vs. (11) USC Trojans/Virginia Commonwealth University Rams
#
#  (7) Texas A&M Aggies vs. (10) Purdue Boilermakers
#  (2) Notre Dame Fighting Irish vs. (15) Akron Zips

southwest = ["Kansas", "Notre Dame", "Purdue", "Louisville", "Vanderbilt", "Georgetown", "Texas A&M",
  "Nevada Las Vegas", "Illinois", "Purdue", reduce(["Southern California", "Virginia Commonwealth"])[0], 
  "Richmond", "Morehead St.", "St. Peter's", "Akron", "Boston University"]

# SOUTHEAST
#  (1) Pittsburgh Panthers vs. (16) UNC Asheville/Arkansas Little-Rock
#  (8) Butler Bulldogs vs. (9) Old Dominion Monarchs
#
#  (4) Wisconsin Badgers vs. (13) Belmont Bruins
#  (5) Kansas State Wildcats vs. (12) Utah State Aggies
#
#  (3) BYU Cougars vs. (14) Wofford Terriers
#  (6) St. John’s Red Storm vs. (11) Gonzaga Bulldogs
#
#  (7) Michigan State Spartans vs. (10) UCLA Bruins
#  (2) Florida Gators vs. (15) UC-Santa Barbara Gouchos

southeast = ["Pittsburgh", "Florida", "Brigham Young", "Wisconsin", "Kansas St.", "St. John's", "Michigan St.",
  "Butler", "Old Dominion", "UCLA", "Gonzaga", "Utah St.", "Belmont", "Wofford", 
  "UC Santa Barbara", reduce(["NC Asheville","Arkansas Little Rock"])[0]]

# This order is important so that the proper teams meet in the final four.
regions = [ east, west, southeast, southwest]

final_four_teams = []


File.open("winners.txt",'w') do |f|
  
  # Play through all four regionals and come up with a Final Four
  regions.each do |region|
    rounds = 1
    while region.length() > 1
      puts "ROUND " + rounds.to_s
      f.puts "ROUND " + rounds.to_s
      region = reduce(region)
    
      region.each do |winner|
      f.puts winner
      end
    
      f.puts
      rounds = rounds + 1
    end

    final_four_teams << region[0]
  end




  puts "FINAL FOUR"
  f.puts "FINAL FOUR"
  f.puts final_four_teams[0]
  f.puts final_four_teams[1]
  f.puts final_four_teams[2]
  f.puts final_four_teams[3]
  f.puts
  
  finalists = reduce(final_four_teams)
  f.puts "FINALISTS"
  f.puts finalists[0]
  f.puts finalists[1]
  f.puts
  
  puts "NATIONAL CHAMPION" 
  f.puts "NATIONAL CHAMPION"
  f.puts reduce(finalists)[0]

end