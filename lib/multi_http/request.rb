# frozen_string_literal: true

module MultiHttp
  # MultiHttp::Request
  class Request
    METHODS = %w[GET POST PUT PATCH DELETE HEAD].to_set
    private_constant :METHODS

    # @param [String] method
    # @param [String] uri
    # @param [String] body
    # @return [void]
    def initialize(method:, uri:, body: '')
      raise ArgumentError unless METHODS.include?(method)

      @method = method
      @uri = URI.parse(uri).to_s
      @body = body
    end

    # @return [Hash]
    def to_h
      { 'method' => method, 'uri' => uri, 'body' => body }
    end

    private

    # @!attribute [r] method
    # @return [String]
    attr_reader :method
    # @!attribute [r] uri
    # @return [String]
    attr_reader :uri
    # @!attribute [r] body
    # @return [String]
    attr_reader :body
  end
end
