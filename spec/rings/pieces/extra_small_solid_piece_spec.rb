require 'spec_helper'
require 'rings/pieces/extra_small_solid_piece'
require 'support/shared_examples_for_piece'

describe Pieces::ExtraSmallSolidPiece do
  it_behaves_like Piece do    
    describe "#solid?" do
      specify { subject.solid?.should be_true }
    end

    describe "#size" do
      specify { subject.size.should == :extra_small }  
    end

    describe "#type" do
      specify { subject.type.should == :extra_small_solid_piece }
    end
  end
end