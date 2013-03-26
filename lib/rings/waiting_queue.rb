require 'set'
require 'forwardable'

module Rings
  class WaitingQueue
    extend Forwardable
    def_delegators :@items, :each
    def_delegator :@items, :add, :enqueue    
    def_delegator :@items, :delete, :dequeue

    @@queues = Hash.new

    private_class_method :new

    def self.instance_for capacity
      @@queues[capacity] ||= new capacity
    end

    def initialize capacity
      @items = Set.new
      @capacity = capacity
    end

    def self.withdraw item
      @@queues.values.each { |queue| queue.dequeue item }
    end

    def destroy
      @@queues.delete @capacity
    end

    def ready?
      @items.size >= @capacity
    end
  end
end