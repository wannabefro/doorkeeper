module Doorkeeper
  module OAuth
    class Scopes
      include Enumerable
      include Comparable

      def self.from_string(string)
        string ||= ""
        from_array string.split
      end

      def self.from_array(array)
        new.tap do |scope|
          scope.add *array
        end
      end

      delegate :each, to: :@scopes

      def initialize
        @scopes = Set.new
      end

      def exists?(scope)
        @scopes.include? scope.to_sym
      end

      def add(*scopes)
        @scopes.merge scopes.map(&:to_sym)
      end

      def all
        @scopes.to_a
      end

      def to_s
        all.join(" ")
      end

      def has_scopes?(scopes)
        scopes.all? { |s| exists?(s) }
      end

      def +(other)
        if other.is_a? Scopes
          self.class.from_array(self.all + other.all)
        else
          super(other)
        end
      end

      def <=>(other)
        self.sort <=> other.sort
      end
    end
  end
end
