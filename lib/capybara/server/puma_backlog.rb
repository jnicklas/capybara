# frozen_string_literal: true

module Capybara
  class Server
    class PumaBacklog
      def initialize(server)
        @server = server
      end

      def positive?
        @server.backlog.to_i.positive?
      end
    end
  end
end
