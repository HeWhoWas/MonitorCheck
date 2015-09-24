### This is a base class for all checks to extend from.
class BaseCheck
  #Boolean field that returns true if the check failed.
  attr_accessor :failed
  alias_method :failed?, :failed
  #String field that contains any output to be printed in verbose mode, or included in notification bodies.
  attr_accessor :output
  #A hash that can be populated with key/value pairs for notifications to access.
  attr_accessor :values

  #Static accessor, required params is a hash of name/description for required parameters.
  class << self
    attr_accessor :required_params
  end

  def initialize
    @values = {}
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