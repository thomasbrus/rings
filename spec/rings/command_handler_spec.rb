require 'spec_helper'
require 'rings/command_handler'
require 'support/shared_examples_for_command_handler'

describe CommandHandler do  
  it_behaves_like CommandHandler

  describe ".command" do
    specify do
      expect { described_class.command }.to raise_error NotImplementedError
    end
  end
end