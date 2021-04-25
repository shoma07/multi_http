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
  extend FFI::Library

  ffi_lib File.expand_path('multi_http/multi_http.so', __dir__)
  attach_function :multihttp, %i[string int], :string
  private_class_method :multihttp

  class << self
    # @param [Array<MultiHttp::Request>] requests
    # @param [Integer] max
    # @return [Array<MultiHttp::Response>]
    def call(requests, max = 10)
      Response.build_list_by_json(multihttp(requests.map(&:to_h).to_json, max))
    end
  end
end
