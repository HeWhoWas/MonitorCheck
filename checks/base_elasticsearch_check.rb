require_relative('base_check')
class BaseElasticsearchCheck < BaseCheck

  @@required_params = {'es_url' => 'Elasticsearch URL to connect to',
                      'es_index' => 'Elasticsearch index to use for check'}

  def execute(params={})
    validate_params(params)

    if response_time.real > ((params['timeout'].to_i * 1.0) / 1000)
      @failed = true
      @output = "Exceeded timeout value of #{params['timeout']} milliseconds. Time taken: #{(response_time.real * 1000).round(2)} milliseconds"
    elsif response.code.to_s == params['response']
      @failed = false
      @output = "#{params['url']} responded with #{response.code.to_s} in #{(response_time.real * 1000).round(2)} milliseconds"
    else
      @failed = true
      @output = "Response code #{response.code.to_s} does not match required value of #{params['response']}"
    end
  end

end