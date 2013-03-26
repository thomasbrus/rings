require 'spec_helper'
require 'rings/pieces/small_ring_piece'
require 'support/shared_examples_for_piece'

describe Pieces::SmallRingPiece do
  it_behaves_like Piece
  subject { described_class.new :yellow }
  it { should_not be_solid }
  its(:size) { should == :small }
end