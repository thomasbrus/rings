require 'spec_helper'
require 'rings/piece'
require 'support/shared_examples_for_piece'

describe Piece do
  it_behaves_like Piece do
    before(:each) do
      described_class.any_instance.stub(:solid?).and_return(:ok)
      described_class.any_instance.stub(:size).and_return(:bogus)
    end

    describe "#type" do
      specify { subject.type.should == :bogus_solid_piece }
    end
  end
end
