class Rings::Piece
  attr_reader color: Symbol
  def initialize: (Symbol) -> void
  def solid?: () -> bool
  def size: () -> Symbol
  def type: () -> Symbol
  def ==: (any) -> bool
end

Rings::Piece::ALLOWED_COLORS: Array<Symbol>
