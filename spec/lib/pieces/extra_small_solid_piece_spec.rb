require 'spec_helper'
require 'rings/pieces/extra_small_solid_piece'
require 'support/shared_examples_for_piece'

describe Pieces::ExtraSmallSolidPiece do
  it_behaves_like Piece
  subject { described_class.new :yellow }
  it { should be_solid }
  its(:size) { should == :extra_small }
end