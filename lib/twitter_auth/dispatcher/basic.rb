require 'net/http'

module TwitterAuth
  module Dispatcher
    class Basic
      attr_accessor :user

      def initialize(user)
        raise TwitterAuth::Error, 'Dispatcher must be initialized with a User.' unless user.is_a?(TwitterAuth::BasicUser)
        self.user = user
      end

      def request(http_method, path, *arguments)
        path << '.json' unless path.match(/\.(:?xml|json)\z/i)

        response = TwitterAuth.net.start{ |http|
          req = "Net::HTTP::#{http_method.to_s.capitalize}".constantize.new(path, *arguments)
          req.basic_auth user.login, user.password
          http.request(req)
        }
        
        JSON.parse(response.body)
      rescue JSON::ParserError
        response.body
      end

      def get(path, *arguments)
        request(:get, path, *arguments)
      end

      def post(path, *arguments)
        request(:post, path, *arguments)
      end

      def put(path, *arguments)
        request(:put, path, *arguments)
      end

      def delete(path, *arguments)
        request(:delete, path, *arguments)
      end
    end
  end
end
