require_relative('base_notification')
class HttpNotification < BaseNotification

  @@required_params = {"notify_url" => "The URL to POST HTTP data to."}

  #Performs an HTTP POST against the given URL.
  def send(params, check)
    validate_params(params)
    status = check.failed? ? "FAILED" : "SUCCESS"
    begin
      client = HTTPClient.new
      response = client.post(params['notify_url'], {"result" => status, "output" => check.output})
      @failed = response.code != 200 ? true : false
      @output = response.code.to_s
    rescue => error
      @failed = true
      @output = error.message
    end
  end

end