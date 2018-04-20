module OmniAuth
  module Strategies
    class Email
      include OmniAuth::Strategy

      def request_phase
        call_app!
      end

      def callback_phase
        return fail!(:invalid_credentials) unless email_from_token
        super
      end

      uid do
        email_from_token
      end

      info do
        {
          name: email_from_token.split('@').first,
          email: email_from_token
        }
      end

      def email_from_token
        @email ||= Rails.cache.read "auth:email:#{request[:token]}"
      end

      def self.token_for_email(email)
        token = SecureRandom.hex
        Rails.cache.write "auth:email:#{token}", email, expires_in: 5.minutes
        token
      end
    end
  end
end
