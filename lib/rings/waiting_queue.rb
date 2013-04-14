require 'forwardable'

module Rings
  class WaitingQueue
    extend Forwardable
    def_delegators :@items, :each
    def_delegator :@items, :delete, :dequeue

    @@queues = {}

    private_class_method :new

    class CapacityReachedError < RuntimeError; end

    def self.instance_for capacity
      @@queues[capacity] ||= new capacity
    end

    def initialize capacity
      @items = []
      @capacity = capacity
    end

    def self.withdraw item
      @@queues.values.each { |queue| queue.dequeue item }
    end

    def enqueue item
      unless @items.include? item
        raise CapacityReachedError, "Cannot enqueue another item, capacity is reached" if ready?
        @items.push(item)
      end
    end

    def to_a
      @items.dup
    end

    def ready?
      @items.size >= @capacity
    end
  end
end