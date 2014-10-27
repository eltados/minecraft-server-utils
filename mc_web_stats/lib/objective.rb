class Objective
  attr_accessor :objective_name, :display_name, :player_scores

  def initialize( objective_name, display_name )
    @objective_name = objective_name
    @display_name = display_name
    @player_scores = {}
  end

  def get_sorted_scores
    return @players_scores.sort_by { |player_name, score| score }.reverse
  end
end
