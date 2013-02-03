module Doorkeeper
  module Models
    module Scopes
      # Return the scope string as scope object
      #
      # @return [Scopes]
      def oauth_scope
        OAuth::Scopes.from_string self.scope
      end
    end
  end
end
