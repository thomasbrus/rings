class Matrix
  def self.build: (Integer, Integer) { (Integer, Integer) -> any } -> Matrix
  def each: { (Rings::Field) -> any } -> any
  def []: (Integer, Integer)-> Rings::Field
  def select: { (Rings::Field) -> bool } -> Array<Rings::Field>
end
