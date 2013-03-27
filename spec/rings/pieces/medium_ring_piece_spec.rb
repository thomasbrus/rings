require 'spec_helper'
require 'rings/pieces/medium_ring_piece'
require 'support/shared_examples_for_piece'

describe Pieces::MediumRingPiece do
  it_behaves_like Piece do
    describe "#solid?" do
      specify { subject.solid?.should be_false }
    end

    describe "#size" do
      specify { subject.size.should == :medium }  
    end

    describe "#kind" do
      specify { subject.kind.should == :medium_ring_piece }
    end
  end
end