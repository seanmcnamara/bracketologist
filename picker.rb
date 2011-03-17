!#/usr/bin/env ruby

# Applies the log5 formula to determine the odds of one team beating another.
def log5(a, b)
  return a*(1 - b)/(a*(1 - b) + (1 - a)*b)
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
