require 'spec_helper'
require 'rings/waiting_queue'

describe WaitingQueue do
  specify { described_class.should_not respond_to :new }

  # TODO: describe "#items"

  describe "#ready?" do
    context "when the capacity of the queue is zero" do
      subject { WaitingQueue.instance_for 0 }
      after(:each) { subject.destroy }
      it { should be_ready }
    end

    context "when the capacity of the queue is two" do
      let(:first_item) { double :item }
      let(:second_item) { double :item }
      let(:third_item) { double :item }

      subject { WaitingQueue.instance_for 2 }
      after(:each) { subject.destroy }

      it { should_not be_ready }

      context "when the same item is enqueued twice" do
        before(:each) do
          2.times { subject.enqueue first_item }
        end

        it { should_not be_ready }
      end

      context "when two unique items are enqueued" do
        before(:each) do
          subject.enqueue first_item
          subject.enqueue second_item
        end

        it { should be_ready }
      end

      context "when more than two items are enqueued" do
        before(:each) do
          subject.enqueue first_item
          subject.enqueue second_item
          subject.enqueue third_item
        end

        it { should be_ready }
      end
    end
  end

  describe ".withdraw" do
    context "when an item is in three queues" do
      let(:item) { double :item }
      let(:first_waiting_queue) { WaitingQueue.instance_for 3 }
      let(:second_waiting_queue) { WaitingQueue.instance_for 4 }
      let(:third_waiting_queue) { WaitingQueue.instance_for 1 }

      before(:each) do
        first_waiting_queue.enqueue item
        second_waiting_queue.enqueue item
        third_waiting_queue.enqueue item
      end

      after(:each) do
        first_waiting_queue.destroy
        second_waiting_queue.destroy
        third_waiting_queue.destroy
      end

      it "withdraws the item from all queues" do
        # described_class.withdraw(item).should =~ [first_waiting_queue, second_waiting_queue, third_waiting_queue]
        # first_waiting_queue.should_not include item
        # third_waiting_queue.should_not be_ready
      end    
    end
    
  end
end