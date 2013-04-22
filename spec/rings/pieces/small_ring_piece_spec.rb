require 'spec_helper'
require 'rings/pieces/small_ring_piece'
require 'support/shared_examples_for_piece'

describe Pieces::SmallRingPiece do
  it_behaves_like Piece do
    describe "#solid?" do
      specify { subject.solid?.should be_false }
    end

    describe "#size" do
      specify { subject.size.should == :small }  
    end

    describe "#type" do
      specify { subject.type.should == :small_ring_piece }
    end
  end
end
