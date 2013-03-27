require 'spec_helper'
require 'rings/command_handling'

describe CommandHandling do
  subject { Class.new { include CommandHandling }.new }
  it { should_not respond_to :parse_arguments }

  describe ".has_arguments" do
    context "given invalid argument options" do
      it "throws an error" do
        expect { subject.class.send :has_arguments, arg: :something
        }.to raise_error CommandHandling::CommandError, /invalid format/i
      end
      it { should_not respond_to :parse_arguments }
    end

    context "given valid argument options" do
      before(:each) do
        subject.class.send :has_arguments,
          nickname: :string, age: :integer, smoker: :boolean
      end

      describe "#parse_arguments" do
        context "given too few arguments" do
          it "throws an error" do
            expect {
              subject.parse_arguments("thomas")
            }.to raise_error CommandHandling::CommandError, /wrong number of arguments/i
          end
        end

        context "given too many arguments" do
          it "throws an error" do
            expect {
              subject.parse_arguments(*%w[thomas 21 0 Enschede])
            }.to raise_error CommandHandling::CommandError, /wrong number of arguments/i
          end
        end

        context "given incorrectly formatted arguments" do
          it "throws an error" do
            expect {            
              subject.parse_arguments("th~o.mas", "-21", "4")
            }.to raise_error CommandHandling::CommandError, /could not parse/i
          end
        end

        context "given valid arguments" do
          let(:arguments) { subject.parse_arguments(*%w[thomas 21 0]) }
          it "parses the arguments" do
            arguments.should == { nickname: "thomas", age: 21, smoker: false }
          end
        end
      end
    end
  end
end