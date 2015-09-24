require_relative('base_elasticsearch_check')
class ElasticsearchResponseCodeCheck < BaseElasticsearchCheck

  @@required_params = @@required_params.merge!({'test' => 'Elasticsearch URL to connect to'})

  def execute(params={})
    validate_params(params)
    
  end

end