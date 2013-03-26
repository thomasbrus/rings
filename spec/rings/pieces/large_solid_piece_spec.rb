require 'spec_helper'
require 'rings/pieces/large_solid_piece'
require 'support/shared_examples_for_piece'

describe Pieces::LargeSolidPiece do
  it_behaves_like Piece
  subject { described_class.new :yellow }
  it { should be_solid }
  its(:size) { should == :large }
end