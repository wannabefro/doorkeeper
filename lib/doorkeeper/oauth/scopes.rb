module Doorkeeper
  module OAuth
    # Handle OAuth scopes logic
    #
    # @example
    #
    #   scopes = Scopes.parse 'public admin'
    #   # => #<Scope public, admin>
    #   scopes.add :write
    #   # => #<Scope public, admin, write>
    #   scopes.exists? :admin
    #   # => true
    #   scopes == Scopes.parse 'public admin write'
    #   # => true
    #
    class Scopes
      include Enumerable
      include Comparable

      # Parses scopes from string or array
      #
      # @example
      #
      #   scopes = Scopes.parse 'public admin'
      #   # => #<Scope public, admin>
      #
      #   scopes = Scopes.parse [:public, :admin]
      #   # => #<Scope public, admin>
      #
      # @return [Scopes]
      #
      def self.parse(scopes)
        scopes = case scopes
          when String then scopes.split
          when Array  then scopes
        end

        new.tap do |s|
          s.add *scopes
        end
      end

      delegate :each, to: :@scopes

      def initialize
        @scopes = Set.new
      end

      # Check for existence of scope
      #
      # @example
      #
      #   scopes = Scopes.parse 'public admin'
      #   # => #<Scope public, admin>
      #   scopes.exists? :admin
      #   # => true
      #   scopes.exists? 'admin'
      #   # => true
      #
      # @param [String, Array] scope
      #
      def exists?(scope)
        @scopes.include? scope.to_sym
      end

      # Add scopes to set if not already included (works as set)
      #
      # @example
      #
      #   scopes = Scopes.parse 'public'
      #   # => #<Scope public>
      #   scopes.add :write, :other
      #   # => #<Scope public, write, other>
      #   scopes.add :write
      #   # => #<Scope public, write, other>
      #   scopes.add 'one-more'
      #   # => #<Scope public, write, other, one-more>
      #
      # @param [String, Array] scopes
      # @return [Scopes]
      #
      def add(*scopes)
        @scopes.merge scopes.map(&:to_sym)
      end

      # Return all scopes as array
      # @return [Array]
      def all
        @scopes.to_a
      end

      # Return all scopes as OAuth scope string
      # @return [String]
      def to_s
        all.join(" ")
      end

      # Checks if the given scope is a subset of the scope
      #
      # @example
      #
      #   scopes = Scopes.parse 'public admin'
      #   # => #<Scope public, admin>
      #   scopes.has_scopes? Scopes.parse('admin')
      #   # => true
      #   scopes.has_scopes? Scopes.parse('public admin')
      #   # => true
      #   scopes.has_scopes? Scopes.parse('not')
      #   # => false
      #   scopes.has_scopes? Scopes.parse('public not')
      #   # => false
      #
      # @param [Scopes] scopes the scopes object to compare
      #
      def has_scopes?(scopes)
        scopes.all? { |s| exists?(s) }
      end

      # Joins two scopes
      #
      # @example
      #
      #   Scopes.parse('a') + Scopes.parse('b')
      #   # => #<Scopes a, b>
      #
      # @param [Scopes] other
      # @returns [Scopes]
      def +(other)
        if other.is_a? Scopes
          self.class.parse(self.all + other.all)
        else
          super(other)
        end
      end

      # Compare two scopes independent of the order
      def <=>(other)
        self.sort <=> other.sort
      end

      # Inspect the object
      def inspect
        "#<Scopes #{all.join(', ')}>"
      end
    end
  end
end
