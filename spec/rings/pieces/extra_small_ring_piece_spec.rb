require 'spec_helper'
require 'rings/pieces/extra_small_ring_piece'
require 'support/shared_examples_for_piece'

describe Pieces::ExtraSmallRingPiece do
  it_behaves_like Piece do    
    describe "#solid?" do
      specify { subject.solid?.should be_false }
    end

    describe "#size" do
      specify { subject.size.should == :extra_small }  
    end

    describe "#type" do
      specify { subject.type.should == :extra_small_ring_piece }
    end
  end
end
