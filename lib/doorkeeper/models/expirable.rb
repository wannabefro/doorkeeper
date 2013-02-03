module Doorkeeper
  module Models
    # Provides helpers for token expiration
    #
    # @example
    #
    #   token.created_at = Time.now.utc
    #   token.expires_in = 10.seconds
    #   token.expired?
    #   # => false
    #   # 11 seconds passes
    #   token.expired?
    #   # => true
    #
    module Expirable
      # Check if the token is expired since it's creation
      def expired?
        expires_in && Time.now > expired_time
      end

      # Reset the expiration time for a given token
      #
      # @param at time in seconds
      # @return [Integer] time in seconds
      def expire(at = 0)
        self.expires_in = at
      end

      # Reset the expiration time for a given token and saves the model
      #
      # @param at time in seconds
      # @return [Boolean] true if the model was saved
      def expire!(at = 0)
        expire at
        save validate: false
      end

      # Time in seconds for the token to expire
      #
      # @return [Integer] time in seconds
      def seconds_to_expire
        return nil if expires_in.nil?
        expires = (created_at + expires_in.seconds) - Time.now
        expires_sec = expires.seconds.round(0)
        expires_sec > 0 ? expires_sec : 0
      end

      # The expiration time since the token was issued
      #
      # @return [Time]
      def expired_time
        created_at + expires_in.seconds
      end
      private :expired_time
    end
  end
end
