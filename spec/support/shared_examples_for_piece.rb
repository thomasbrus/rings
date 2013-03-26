shared_examples_for Piece do
  subject { described_class.new :green }
  it { should respond_to(:solid?) }
  it { should respond_to(:size) } 
  
  it "can create a piece with an allowed color" do
    expect {
      described_class.new Piece::ALLOWED_COLORS.first
    }.to_not raise_error ArgumentError
  end

  it "cannot create a piece with an invalid color" do
    expect {
      described_class.new :hello_world
    }.to raise_error ArgumentError
  end
end