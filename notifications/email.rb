require_relative('base_notification')
class EmailNotification < BaseNotification

  #Sends an email.
  def send(params, check)
    validate_params(params)
    if check.failed?
      subject = "CHECK FAILURE: #{check.class.name}"
    else
      subject = "CHECK SUCCEEDED: #{check.class.name}"
    end
    begin
      Pony.mail(:to => params['to'], :from => 'alerts@example.com', :subject => subject, :body => check.output)
      @failed = false
    rescue => error
      @failed = true
      @output = error.message
    end
  end

  def help
    'Email Notification uses sendmail to send an email and requires the following params:
      to = <EMAIL>

    Example:
      Email to|ben.bettridge@example.com'
  end

  def validate_params(params)
    if params['to'].nil?
      raise ArgumentError.new("No 'to' parameter provided")
    end
  end

  def failed?
    @failed
  end

  def output
    @output
  end
end