class Rings::Field
  @x: Integer
  @y: Integer
  @pieces: Set<Rings::Piece>
  def initialize: (Integer, Integer) -> void
  def place: (Rings::Piece) -> void
  def can_place?: (Rings::Piece) -> bool
  def has_piece_of_size?: (Symbol) -> bool
  def has_piece_of_color?: (Symbol) -> bool
  def has_solid_piece?: () -> bool
  def has_solid_piece_of_color?: (any) -> bool
  def number_of_pieces_of_color: (any) -> bool
end
