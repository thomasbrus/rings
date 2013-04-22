require 'spec_helper'
require 'rings/command_handling'

describe CommandHandling do
  subject { Class.new { include CommandHandling }.new }
  it { should_not respond_to :parse_arguments }

  describe ".has_arguments" do
    context "given invalid argument options" do
      it "raises an error" do
        expect {
          subject.class.send :has_arguments, arg: :something
        }.to raise_error CommandHandling::CommandError, /invalid argument options/i
      end
      
      it { should_not respond_to :parse_arguments }
    end

    context "given valid argument options" do
      before(:each) do
        arguments = { nickname: :string, age: :integer, smoker: :boolean }
        subject.class.send :has_arguments, arguments
      end

      describe "#arguments" do
        context "when no arguments are parsed" do
          context "given an invalid argument name" do
            specify { subject.arguments(:something).should be_nil }  
          end          
        end

        context "when valid arguments are parsed" do
          context "given an valid argument name" do
            before(:each) do
              subject.parse_arguments %w[thomas 21 0]
            end

            specify { subject.arguments(:nickname).should_not be_nil }
          end
        end
      end

      describe "#parse_arguments" do
        context "given too few arguments" do
          it "raises an error" do
            expect {
              subject.parse_arguments ["thomas"]
            }.to raise_error CommandHandling::CommandError, /wrong number of arguments/i
          end
        end

        context "given too many arguments" do
          it "raises an error" do
            expect {
              subject.parse_arguments %w[thomas 21 0 Enschede]
            }.to raise_error CommandHandling::CommandError, /wrong number of arguments/i
          end
        end

        context "given incorrectly formatted arguments" do
          it "raises an error" do
            expect {            
              subject.parse_arguments ["thomas", "-21", "4"]
            }.to raise_error CommandHandling::CommandError, /could not parse/i
          end
        end

        context "given valid arguments" do
          it "parses integer arguments correctly" do
            subject.class.send :has_arguments, age: :integer
            parsed_arguments = subject.parse_arguments ["21"]
            parsed_arguments[:age].should == 21   
          end

          it "parses boolean arguments correctly" do
            subject.class.send :has_arguments, smoker: :boolean
            parsed_arguments = subject.parse_arguments ["0"]
            parsed_arguments[:smoker].should be_false
          end

          it "parses string arguments correctly" do
            subject.class.send :has_arguments, name: :string
            parsed_arguments = subject.parse_arguments ["thomas%20brus"]
            parsed_arguments[:name].should == "thomas brus"
          end
        end
      end
    end
  end
end
