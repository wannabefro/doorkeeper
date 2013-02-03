module Doorkeeper
  module Models
    module Revocable
      def revoke
        self.revoked_at = Time.now.utc
      end

      def revoke!
        revoke
        save validate: false
      end

      def revoked?
        revoked_at.present?
      end
    end
  end
end
