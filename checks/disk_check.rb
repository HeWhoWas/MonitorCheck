require_relative('base_check')
class DiskCheck < BaseCheck
  
  def execute(params={})
    validate_params(params)

    normalized_threshold = normalize_threshold(params['threshold'])
    stat = Sys::Filesystem.stat(params['path'])
    percentage_free = (stat.blocks_available / stat.blocks) * 100

    if percentage_free < normalized_threshold
      @failed = false
    else
      @failed = true
    end

    mb_total = stat.block_size * stat.blocks / 1024 /1024
    mb_available = stat.block_size * stat.blocks_available / 1024 / 1024
    @output = "Total MB:\t#{mb_total}\t\tAvail MB:\t#{mb_available}\t\tUsage:\t#{percentage_free}"
  end

  def help
    'DiskCheck requires the following params:
      path = <FILE PATH>
      threshold = <PERCENTAGE>

    Example:
      DiskCheck path|/ threshold|90%

    Note: threshold is limited to an integer'
  end

  def validate_params(params)
    if params['path'].nil?
      raise ArgumentError.new("No 'path' parameter provided")
    end
    if params['threshold'].nil?
      raise ArgumentError.new("No 'threshold' parameter provided")
    elsif normalize_threshold(params['threshold']).nil?
      raise ArgumentError.new("'threshold' param needs to be an integer with or without '%'. E.g: 50% or 50")
    end
  end

  def failed?
    @failed
  end

  protected

  def normalize_threshold(threshold)
    if threshold.include?("%")
      threshold = threshold.tr('%','')
    end
    Integer(threshold) rescue nil
  end

end