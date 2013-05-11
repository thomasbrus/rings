class MockBlock
  def to_proc
    ->(*args) { call(*args) }
  end
end
