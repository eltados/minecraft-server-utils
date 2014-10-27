require 'yaml'
require_relative 'objective'

def parse_file
#  yaml_string = `nbt2yaml_pLAN`
  yaml_string = `nbt2yaml /var/games/minecraft/backup/pLAN/pLAN/data/scoreboard.dat`
  yaml_string = yaml_string.split("\n")[2..-1].join "\n"
  after_string = ''
  yaml_string.each_line do |line|
    line = line.sub( '-', '' )
    after_string << line
  end
  return YAML::load( after_string )
end

def get_score_hash
  yaml_string = `nbt2yaml /var/games/minecraft/backup/pLAN/pLAN/data/scoreboard.dat`
  scoreboard = YAML::load( yaml_string )
  score_hash = {}

  objectives = scoreboard[''][0]['data'][1]['Objectives']
  objectives.each do |objective|
    score_hash[objective[0]['Name']] = {}
  end

  player_scores = scoreboard[''][0]['data'][3]['PlayerScores']
  player_scores.each do |score|
    score_hash[score[3]['Objective']][score[0]['Name']] = score[2]['Score']
  end
  return score_hash
end

def get_sorted_score
  score_hash = get_score_hash
  score_hash.each do |key, value|
    score_hash[key] = value.sort_by { |key, value| value }.reverse
  end
  return score_hash
end

def get_objectives
  scoreboard = parse_file
  objectives = scoreboard['Objectives']
  player_scores = scoreboard['PlayerScores']
  return_objectives = {}

  objectives.each do |objective|
    newObjective = Objective.new( objective['Name'], objective['DisplayName'] )
    return_objectives[objective['Name']] = newObjective
  end

  player_scores.each do |score|
    objective = return_objectives[score['Objective']]
    objective.player_scores[score['Name']] = score['Score']
  end

  return return_objectives
end

def get_scores
  scoreboard = parse_file
  objectives = scoreboard['Objectives']
  player_scores = scoreboard['PlayerScores']
  score_hash = {}

  objectives.each do |objective|
    score_hash[objective['Name']] = {}
    score_hash[objective['Name']]['DisplayName'] = objective['DisplayName']
  end

  player_scores.each do |score|
    score_hash[score['Objective']][score['Name']] = score['Score']
  end

  return score_hash
end
