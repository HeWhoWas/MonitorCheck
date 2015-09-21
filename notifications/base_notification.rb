### This is a base class for all notifications to extend from.
class BaseNotification
  attr_accessor :failed
  attr_accessor :output
  alias_method :failed?, :failed

  #This function should implement the notification itself
  def send(params={}, check)
    raise NotImplementedError
  end

  #Supply a help message for the notification
  def help
    required_params = self.class.class_variable_get('@@required_params')
    retval = "\n#{self.class.name} requires the following params:"
    required_params.each do |name, desc|
      retval << "\n\t#{name}\t=\t#{desc}"
    end
    retval
  end

  protected

  #Validates the required parameters for the check
  def validate_params(params)
    required_params = self.class.class_variable_get('@@required_params')
    required_params.each do |name, desc|
      if params[name].nil?
        raise ArgumentError.new("No '#{name}' parameter provided")
      end
    end
  end

end