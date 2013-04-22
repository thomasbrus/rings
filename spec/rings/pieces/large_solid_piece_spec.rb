require 'spec_helper'
require 'rings/pieces/large_solid_piece'
require 'support/shared_examples_for_piece'

describe Pieces::LargeSolidPiece do
  it_behaves_like Piece do
    describe "#solid?" do
      specify { subject.solid?.should be_true }
    end

    describe "#size" do
      specify { subject.size.should == :large }  
    end

    describe "#type" do
      specify { subject.type.should == :large_solid_piece }
    end
  end
end
