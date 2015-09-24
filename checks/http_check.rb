require_relative('base_check')
require('benchmark')
class HttpCheck < BaseCheck

  @@required_params = {"url" => "The URL to test.",
                       "response" => "The response code to expect returned.",
                       "timeout" => "The timeout value in milliseconds to trigger an alert."}

  def execute(params={})
    validate_params(params)
    client = HTTPClient.new
    response = nil
    response_time = Benchmark.measure do
      response = client.get(params['url'])
    end
    @values[:response_code] = response.code.to_i
    @values[:response_time] = response_time.real
    if response_time.real > ((params['timeout'].to_i * 1.0) / 1000)
      @failed = true
      @output = "Exceeded timeout value of #{params['timeout']} milliseconds. Time taken: #{(response_time.real * 1000).round(2)} milliseconds"
    elsif response.code.to_s == params['response']
      @failed = false
      @output = "#{params['url']} responded with #{response.code.to_s} in #{(response_time.real * 1000).round(2)} milliseconds"
    else
      @failed = true
      @output = "Response code #{response.code.to_s} does not match required value of #{params['response']}"
    end
  end

end