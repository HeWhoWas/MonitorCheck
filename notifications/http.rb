require_relative('base_notification')
class HttpNotification < BaseNotification

  #Performs an HTTP POST against the given URL.
  def send(params, check)
    validate_params(params)
    status = check.failed? ? "FAILED" : "SUCCESS"
    begin
      client = HTTPClient.new
      response = nil
      response = client.post(params['notify_url'], {"result" => status, "output" => check.output})
      @failed = response.code != 200 ? true : false
      @output = response.code.to_s
    rescue => error
      @failed = true
      @output = error.message
    end
  end

  def help
    'Http Notification will send a check result via POST to an HTTP URL. Post body will contain "output" and "result" fields.

    It requires the following params:
      notify_url = <URL>

    Example:
      Email notify_url|http://www.remoteserver.com/payload.php'
  end

  def validate_params(params)
    if params['notify_url'].nil?
      raise ArgumentError.new("No 'notify_url' parameter provided")
    end
  end

  def failed?
    @failed
  end

  def output
    @output
  end
end