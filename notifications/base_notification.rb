### This is a base class for all notifications to extend from.
class BaseNotification

  def initialize

  end

  #This function should implement the notification itself
  def send(params={}, check)
    raise NotImplementedError
  end

  #Supply a help message for the notification
  def help()
    raise NotImplementedError
  end

  #Should return true if the notification has failed. False otherwise.
  def failed?
    raise NotImplementedError
  end

  #Should return any output produced by the notification
  def output
    return ""
  end

  protected

  def validate_params(params={})

  end

end