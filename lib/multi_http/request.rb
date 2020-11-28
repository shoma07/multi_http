# frozen_string_literal: true

module MultiHttp
  # MultiHttp::Request
  class Request
    METHOD = %w[GET POST PUT PATCH DELETE HEAD].to_set

    # @param [String] method
    # @param [String] uri
    # @param [String] body
    # @return [void]
    def initialize(method:, uri:, body: '')
      @method = (METHOD.include?(method) && method) || (raise Error)
      @uri = URI.parse(uri).to_s
      @body = body
    end

    # @return [Hash]
    def to_h
      { 'method' => @method, 'uri' => @uri, 'body' => @body }
    end
  end
end
