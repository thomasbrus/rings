class Rings::Game
  @board: Rings::Board
  @players: Array<any>
  @current_turn: Integer
  def initialize: (any, any, any) -> void
  def current_player: () -> any
  def is_in_turn?: (any) -> bool
  def take_turn: (any, any, any, any) -> any
  def over?: () -> bool
  def winner: () -> any
  def place_starting_pieces: (any, any) -> any
  def can_place_piece?: (any, any, any) -> bool
  def assign_arsenal_to_players: () -> any
  def find_player_by_color: (any) -> any
  def territory_winners: () -> any
end

Rings::Game::MIN_PLAYERS: Integer
Rings::Game::MAX_PLAYERS: Integer
