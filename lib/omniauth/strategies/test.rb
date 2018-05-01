module OmniAuth
  module Strategies
    class Test
      include OmniAuth::Strategy

      def request_phase
        redirect '/auth/test/callback'
      end

      def callback_phase
        super
      end

      uid do
        '1'
      end

      info do
        {
          name: 'Test',
          email: 'test@example.com',
          nickname: 'test'
        }
      end
    end
  end
end
