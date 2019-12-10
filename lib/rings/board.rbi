class Rings::Board
  @fields: any
  def initialize: () -> void
  def place: (Rings::Piece, Integer, Integer) -> void
  def can_place?: (Rings::Piece, Integer, Integer) -> bool
  def has_piece_of_color?: (Symbol, Integer, Integer) -> bool
  def has_adjacent_solid_piece_of_color?: (Symbol, Integer, Integer) -> bool
  def has_adjacent_piece_of_color?: (Symbol, Integer, Integer) -> bool
  def adjacent_fields: (Integer, Integer) -> Array<Rings::Field>
end

Rings::Board::SIZE: Integer
