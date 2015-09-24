require_relative('base_check')
class BaseElasticsearchCheck < BaseCheck

  @@required_params = {'es_url' => 'Elasticsearch URL to connect to',
                      'es_index' => 'Elasticsearch index to use for check'}

end