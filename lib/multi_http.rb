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

  REQUESTS = 'requests'
  RESPONSES = 'responses'

  extend FFI::Library

  ffi_lib 'lib/multi_http/libmulti_http.dylib'
  attach_function :multi_http, %i[string], :string
  private_class_method :multi_http

  class << self
    # @param [Array<MultiHttp::Request>]
    # @return [Array<MultiHttp::Response>]
    def call(requests)
      JSON.parse(multi_http({ REQUESTS => requests.map(&:to_h) }.to_json))
          .fetch(RESPONSES).map { |response| Response.new(**response.transform_keys(&:to_sym)) }
    end
  end
end
