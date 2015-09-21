require_relative('base_check')
class HttpCheck < BaseCheck

  def execute(params={})
    validate_params(params)
    client = HTTPClient.new
    response = client.get(params['url'])
    if response.code.to_s == params['response']
      @failed = false
    else
      @failed = true
    end
    @output = response.body
  end

  def help
    'HttpCheck requires the following params:
      url = <URL>
      response = <CODE>

    Example:
      HttpCheck url|http://www.google.com response|200'
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