require_relative('elasticsearch_check')
class ElasticsearchResponseCodeCheck < ElasticsearchCheck

  @@required_params = @@required_params.merge!({'test' => 'Elasticsearch URL to connect to'})

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