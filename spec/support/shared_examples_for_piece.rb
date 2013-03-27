shared_examples_for Piece do
  subject { described_class.new :green }

  describe ".new" do
    context "given a valid color" do
      it "can create the piece" do
        expect {
          described_class.new Piece::ALLOWED_COLORS.first
        }.to_not raise_error ArgumentError
      end
    end

    context "given an invalid color " do
      it "cannot create the piece" do
        expect {
          described_class.new :hello_world
        }.to raise_error ArgumentError
      end
    end
  end
end