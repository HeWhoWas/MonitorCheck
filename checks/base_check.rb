### This is a base class for all checks to extend from.
class BaseCheck
  attr_accessor :failed
  attr_accessor :output
  alias_method :failed?, :failed

  class << self
    attr_accessor :required_params
  end

  #This function should implement the check itself and store any results in member variables
  def execute(params={})
    raise NotImplementedError
  end

  #Supply a help message for the check
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