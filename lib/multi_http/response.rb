# frozen_string_literal: true

module MultiHttp
  # MultiHttp::Response
  class Response
    attr_reader :status, :body

    class << self
      # @param [String] json
      # @return [Array<MultiHttp::Response>]
      def build_list_by_json(json)
        JSON.parse(json).map { |attributes| build(attributes) }
      end

      private

      # @param [Hash] attributes
      # @return [MultiHttp::Response]
      def build(attributes)
        new(status: attributes['status'], body: attributes['body'])
      end
    end

    # @param [Integer] status
    # @param [String] body
    # @return [void]
    def initialize(status:, body:)
      raise ArgumentError unless status.is_a?(Integer) && body.is_a?(String)

      @status = status
      @body = body
    end

    # @return [Hash, Array]
    def parsed
      JSON.parse(body)
    end
  end
end
