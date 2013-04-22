require 'rings/piece'

shared_examples_for Rings::Piece do
  subject { described_class.new :green }

  describe ".new" do
    context "given a valid color" do
      it "can create the piece" do
        expect {
          described_class.new :yellow
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

  describe "#==" do
    it "handles equality correctly" do
      described_class.new(:red).should == described_class.new(:red)
    end
  end
end
