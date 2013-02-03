module Doorkeeper
  module Models
    module Scopes
      # Return the scope string as scope object
      #
      # @return [Scopes]
      def oauth_scope
        Doorkeeper.parse_scope self.scope
      end
    end
  end
end
