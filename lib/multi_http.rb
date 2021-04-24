# frozen_string_literal: true

require 'ffi'
require 'json'
require 'set'
require 'uri'
require 'multi_http/version'
require 'multi_http/request'
require 'multi_http/response'

# MultiHttp
module MultiHttp
  class Error < StandardError; end

  extend FFI::Library

  ffi_lib File.expand_path('multi_http/multi_http.so', __dir__)
  attach_function :multi_http, %i[string int], :string
  private_class_method :multi_http

  class << self
    # @param [Array<MultiHttp::Request>]
    # @return [Array<MultiHttp::Response>]
    def call(requests, max = 10)
      JSON.parse(multi_http(requests.map(&:to_h).to_json, max))
          .map { |response| Response.new(status: response['status'], body: response['body']) }
    end
  end
end
