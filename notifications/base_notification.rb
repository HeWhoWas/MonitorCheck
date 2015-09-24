### This is a base class for all notifications to extend from.
class BaseNotification
  #Boolean field that returns true if the notification failed.
  attr_accessor :failed
  alias_method :failed?, :failed
  #String field that contains any output to be printed in verbose mode.
  attr_accessor :output

  #Static accessor, required params is a hash of name/description for required parameters.
  class << self
    attr_accessor :required_params
    attr_accessor :optional_params
  end

  def self.init

  end

  def self.inherited(subclass)
    if self.required_params.nil?
      self.required_params = {}
    end
    if self.optional_params.nil?
      self.optional_params = {}
    end
  end

  #This function should implement the notification itself
  def send(params={}, check)
    raise NotImplementedError
  end

  #Supply a help message for the notification
  def help
    required_params = self.class.class_variable_get('@@required_params')
    begin
      optional_params = self.class.class_variable_get('@@optional_params')
    rescue
      optional_params = {}
    end
    retval = "\n#{self.class.name} supports the following params:\nRequired:"
    required_params.each do |name, desc|
      retval << "\n\t#{name}\t=\t#{desc}"
    end
    if not optional_params.size.nil? and optional_params.size > 0
      retval << "\n\nOptional:"
      optional_params.each do |name, desc|
        retval << "\n\t#{name}\t=\t#{desc}"
      end
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