require_relative('base_check')
require('benchmark')
class HttpCheck < BaseCheck

  def execute(params={})
    validate_params(params)
    client = HTTPClient.new
    response = nil
    response_time = Benchmark.measure do
      response = client.get(params['url'])
    end
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

  def help
    'HttpCheck requires the following params:
      url = <URL>
      response = <CODE>
      timeout = <MILLISECONDS>

    Example:
      HttpCheck url|http://www.google.com response|200 timeout|100'
  end

  def validate_params(params)
    if params['url'].nil?
      raise ArgumentError.new("No 'url' parameter provided")
    end
  end

  def failed?
    @failed
  end

  def output
    @output
  end
end