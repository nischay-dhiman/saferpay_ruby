require "saferpay_ruby/version"
require "saferpay_ruby/configuration"

module SaferpayRuby
  extend Configuration
  class Error < StandardError; end

  class PaymentGatewayApi
    attr_accessor *Configuration::VALID_CONFIG_KEYS
 
    def initialize(options = {})
      options.delete(:endpoint)
      options.delete_if { |k, v| v.nil? }
      @options = SaferpayRuby.options.merge(options)

      @options.each_pair do |key, val|
        send "#{key}=", val
      end
    end

    def initialize_payment_api(options = {})
      http = Net::HTTP.new(endpoint.host, endpoint.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
  
      request = Net::HTTP::Post.new(endpoint)
      request["content-type"] = 'application/json; charset=utf-8'
      request["accept"] = 'application/json'
      request["authorization"] = authentication

      request.body = {
        "RequestHeader": {
          "SpecVersion": "1.7",
          "CustomerId": customer_id,
          "RequestId": options[:request_id],
          "RetryIndicator": 0
        },
        "TerminalId": terminal_id,
        "Payment": {
          "Amount": {
            "Value": options[:amount],
            "CurrencyCode": options[:currency]
          },
          "OrderId": options[:order_id],
          "Description": options[:description]
        },
        "PaymentMethods": options[:payment_methods],
        "ReturnUrls": {
          "Success": success_url,
          "Fail": failure_url
        }
      }.to_json
      http.request(request)
    end

    def initialize_payment_assert_api(options = {})
      http = Net::HTTP.new(assert_endpoint.host, assert_endpoint.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      request = Net::HTTP::Post.new(assert_endpoint)
      request["content-type"] = 'application/json; charset=utf-8'
      request["accept"] = 'application/json'
      request["authorization"] = authentication
      request.body = {
        "RequestHeader": {
          "SpecVersion": "1.15",
          "CustomerId": customer_id,
          "RequestId": options[:request_id],
          "RetryIndicator": 0
        },
        "Token": options[:token]
      }.to_json
      http.request(request)
    end
  end
end
