require_relative('base_notification')
require_relative('../lib/zabbix_sender')
class ZabbixNotification < BaseNotification

  @@required_params = {"zabbix_url" => "The Zabbix host URL to send results to.",
                       "zabbix_host" => "Key of the host"}

  @@optional_params = {"zabbix_filter" => "Comma seperated list of fields (Defined by the check) to send to zabbix. If not supplied, all values are passed through."}

  #Performs an HTTP POST against the given URL.
  def send(params, check)
    validate_params(params)
    @output = ""
    zabbix_client = Zabbix::Sender.new(serv=params['zabbix_url'])
    zabbix_filters = params['zabbix_filter'].nil? ? nil : params['zabbix_filter'].split(',')
    if not check.values.nil?
      results = {}
      check.values.each do | key, value |
        if not zabbix_filters.nil?
          if not zabbix_filters.include?(key)
            continue
          end
        end
        item_key = "zabbixnotification.#{check.class.name}.#{key}"
        results[item_key] = zabbix_client.send(params['zabbix_host'], item_key, value)
      end
      results.each do | item_key, result |
        if result['response'] != 'success' or result['info'].split(';')[1] != " failed: 0"
          @failed = true
          @output << "#{item_key} zabbix send FAILED: #{result['info']}\n"
        end
      end
    end
  end

end