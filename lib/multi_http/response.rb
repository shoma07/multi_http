# frozen_string_literal: true

module MultiHttp
  # MultiHttp::Response
  class Response
    attr_reader :status, :body

    # @param [Integer] status
    # @param [String] body
    # @return [void]
    def initialize(status:, body:)
      @status = status
      @body = body
    end

    # @return [Hash, Array]
    def parsed
      JSON.parse(@body)
    end
  end
end
