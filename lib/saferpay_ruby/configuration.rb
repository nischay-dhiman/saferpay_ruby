module SaferpayRuby
  module Configuration
    DEFAULTS = {
      endpoint: URI('https://test.saferpay.com/api/Payment/v1/PaymentPage/Initialize'),
      user_agent: 'Saferpay Ruby Library',
      terminal_id: "1111111",
      customer_id: "2222222", 
      authentication: 'Basic PVBJXzI0OTYxOF84OTI0Mzc2MDpXZWJvbmlzZUxhYkRvdEMwbQ==',  # Base 64 encoded string of 'username:password'
      success_url: "http://localhost:3010/",
      failure_url: "http://localhost:3010/",
      back_link: nil,
      notify_url: nil,
    }.freeze

    VALID_CONFIG_KEYS = DEFAULTS.keys.freeze

    # Build accessor methods for every config options so we can do this, for example: Saferpay.account_id = 'xxxxx'
    attr_accessor *VALID_CONFIG_KEYS

    def options
      @options = Hash[ * DEFAULTS.map { |key, val| [key, send(key)] }.flatten ].freeze
    end

    # Make sure we have the default values set when we get 'extended'
    def self.extended(base)
      base.reset
    end

    def reset
      options.each_pair do |key, val|
        send "#{key}=", DEFAULTS[key]
      end
    end

    def configure
      yield self
    end
  end
end
