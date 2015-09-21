require_relative('base_notification')
class EmailNotification < BaseNotification

  @@required_params = {"to" => "The email address to send an alert to."}

  #Sends an email.
  def send(params, check)
    validate_params(params)
    subject = check.failed? ? "CHECK FAILURE: #{check.class.name}" : subject = "CHECK SUCCEEDED: #{check.class.name}"
    begin
      Pony.mail(:to => params['to'], :from => 'alerts@example.com', :subject => subject, :body => check.output)
      @failed = false
    rescue => error
      @failed = true
      @output = error.message
    end
  end
end