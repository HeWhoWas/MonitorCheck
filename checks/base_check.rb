### This is a base class for all checks to extend from.
class BaseCheck

  def initialize(params={})

  end

  #This function should implement the check itself and store any results in member variables
  def execute(params={})
    raise NotImplementedError
  end

  #Supply a help message for the check
  def help()
    raise NotImplementedError
  end

  #Should return true if the check has failed. False otherwise.
  def failed?
    raise NotImplementedError
  end

  #Should return any output produced by the check.
  def output
    return ""
  end

  protected

  def validate_params(params={})

  end

end