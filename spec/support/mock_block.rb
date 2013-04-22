class MockBlock
  def to_proc
    lambda { |*args| call(*args) }
  end
end
