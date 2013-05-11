require 'spec_helper'
require 'rings/waiting_queue'

describe WaitingQueue do
  specify { WaitingQueue.should_not respond_to :new }

  describe ".instance_for" do
    context "when called multiple times" do
      it "returns the exact same queue" do
        WaitingQueue.instance_for(2).should be_equal WaitingQueue.instance_for(2)
      end
    end
  end

  describe ".withdraw" do
    context "when an item is in multiple queues" do
      let(:item) { double :item }
      let(:first_waiting_queue) { WaitingQueue.instance_for 3 }
      let(:second_waiting_queue) { WaitingQueue.instance_for 4 }

      before(:each) do
        first_waiting_queue.enqueue item
        second_waiting_queue.enqueue item
      end

      after(:each) do
        first_waiting_queue.instance_variable_set :@items, []
        second_waiting_queue.instance_variable_set :@items, []
      end

      it "removes the item from all queues" do
        first_waiting_queue.should_receive(:dequeue).with(item)
        second_waiting_queue.should_receive(:dequeue).with(item)
        WaitingQueue.withdraw(item)
      end
    end

  end

  describe "#enqueue" do
    let(:first_item) { double :item }
    let(:second_item) { double :item }
    let(:third_item) { double :item }

    subject { WaitingQueue.instance_for 3 }
    after(:each) { subject.instance_variable_set :@items, [] }

    context "when the same item is enqueued twice" do
      before(:each) do
        2.times { subject.enqueue first_item }
      end

      it "only enqueues the first item" do
        subject.to_a.should == [first_item]
      end
    end

    context "when three unique items are enqueued" do
      before(:each) do
        [first_item, second_item, third_item].each { |item| subject.enqueue item }
      end

      it "enqueues the three items" do
        subject.to_a.should == [first_item, second_item, third_item]
      end
    end

    context "when the capacity is exceeded" do
      subject { WaitingQueue.instance_for 2 }

      before(:each) do
        subject.enqueue first_item
        subject.enqueue second_item
      end

      it "raises an error" do
        error = WaitingQueue::CapacityReachedError
        message = /cannot enqueue another item/i
        expect { subject.enqueue third_item }.to raise_error error, message
      end
    end

  end

  describe "#to_a" do
    subject { WaitingQueue.instance_for 2 }

    it "returns a duplicate of its items collection" do
      subject.instance_variable_get(:@items).should_not be_equal subject.to_a
    end
  end

  describe "#ready?" do
    let(:first_item) { double :item }
    let(:second_item) { double :item }
    let(:third_item) { double :item }

    context "given an empty queue" do
      context "when the capacity of the queue is zero" do
        subject { WaitingQueue.instance_for 0 }
        after(:each) { subject.instance_variable_set :@items, [] }
        it { should be_ready }
      end

      context "when the capacity of the queue is two" do
        subject { WaitingQueue.instance_for 2 }
        after(:each) { subject.instance_variable_set :@items, [] }

        it { should_not be_ready }
      end
    end

    context "when the capacity is reached" do
      subject { WaitingQueue.instance_for 2 }
      after(:each) { subject.instance_variable_set :@items, [] }

      before(:each) do
        subject.enqueue first_item
        subject.enqueue second_item
      end

      it { should be_ready }
    end
  end
end
