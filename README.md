# SaferpayRuby

Saferpay JSON application programming interface with a ruby API wrapper built with Net::HTTP

Saferpay API is designed to have predictable, resource-oriented URLs and to use HTTP response codes to indicate API errors. Saferpay use built-in HTTP features, like HTTP authentication and HTTP verbs, which can be understood by off-the-shelf HTTP clients. JSON will be returned in all responses from the API, including errors.

You can contact Saferpay to get ahold of your documentation PDF. Ask for the Payment Page integration documentation.


For more information about Saferpay API, please visit
[https://saferpay.github.io/jsonapi](https://saferpay.github.io/jsonapi)


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'saferpay_ruby'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install saferpay_ruby

## Usage

Following are brief instructions to create and setup a saferpay account for testing.


Firstly You'll need to create a test account on [https://test.saferpay.com](https://test.saferpay.com)


For Production use [https://myportal.six-payment-services.com/](https://myportal.six-payment-services.com/merchantportal/?login&isiweblang=en)


After Logging in, Go to Settings Section,


You'll need to create a Payment Mean / Terminal, Remember to fetch terminalId and customerId.


Add JSON API basic authentication, returning username and password, which will base 64 encoded and then used as authentication header in API


Configure the credentials in saferpay_ruby.rb in initializers as follows:

```
SaferpayRuby.configure do |config|
  config.endpoint = URI('https://test.saferpay.com/api/Payment/v1/PaymentPage/Initialize')
  #config.endpoint = URI('https://www.saferpay.com/api/Payment/v1/PaymentPage/Initialize')  # For production
  config.assert_endpoint = URI('https://test.saferpay.com/api/Payment/v1/PaymentPage/Assert')
  config.terminal_id = "17989968"
  config.customer_id = "240918"
  config.authentication = 'Basic QVBJlzI0OTYxOF84OTI0Mzc2MDpXZWJvbmlzZUxhYkRvdEMpbQ=='
end
```

Transaction Flow
```
  Step 1: Payment Page Initialize
    > Initializes the Payment and generates the RedirectUrl for the Payment Page.
  Step 2: Redirect to the RedirectUrl
  Step 3: Return to ReturnUrl depending on the outcome of the transaction. The ReturnUrls are defined in step 1!
  Step 4: Payment Page Assert
    >Gathers all the information about the payment, like LiabilityShift through 3D Secure and more, using the Token, gathered in step 1!
  Step 5: Depending on the outcome of step 4 you may
    > Capture/Finalize the Transaction
    > Cancel/Abort the Transaction
  Step 6: Transaction is finished!
```
Note: We have only covered Step 1 to Step 4


```
  def initialize_payment
    options = {
      payment_methods: [params[:payment_method]],
      amount: 150 * 100,
      currency: 'EUR',
      order_id: '123123',
      description: 'Payment description',
      request_id: "33e8af17-35c1-4165-a343-c1c86a320f3b"
    }
    service = SaferpayRuby::PaymentGatewayApi.new(
      success_url: "http://localhost:3010/success?order_id=1231&user_id=22",
      failure_url: "http://localhost:3010/failure?order_id=1231&user_id=22"
    )
    response = service.initialize_payment_api(options)

    initialize_assert_api(response, request_id)           #initialize assert API in redirect URL method

    # save the details of transaction response
  end

  def initialize_assert_api(response, request_id)
    # Record the transaction response whether it is success or failure
    options = {
      request_id: request_id,
      token: response['Token']
    }
    service = SaferpayRuby::PaymentGatewayApi.new
    response = service.initialize_payment_assert_api(options)
    response_json = JSON.parse(response.read_body)
  end
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[nischay-dhiman]/saferpay_ruby. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the SaferpayRuby project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[nischay-dhiman]/saferpay_ruby/blob/master/CODE_OF_CONDUCT.md).
