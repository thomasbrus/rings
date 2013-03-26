require 'spec_helper'
require 'rings/pieces/medium_ring_piece'
require 'support/shared_examples_for_piece'

describe Pieces::MediumRingPiece do
  it_behaves_like Piece
  subject { described_class.new :yellow }
  it { should_not be_solid }
  its(:size) { should == :medium }
end