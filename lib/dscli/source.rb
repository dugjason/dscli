class Source < Thor

  desc 'list [page]', 'Lists all Managed Sources'
  def list(page = 1)
    api = Dscli::API.new
    results = api.source_list(page)

    puts "\nTotal Managed Sources: #{results.count}\n\n"
    puts 'ID                               | Name                 | Type                 | Status'
    puts '-----------------------------------------------------------------------------------------------------'

    results[:sources].each { |s| puts "#{s[:id]} | #{ '%-20.20s' % s[:name] } | #{ '%-20.20s' % s[:source_type] } | #{s[:status]}" }
    puts "\n"
  end

  desc 'get (id)', 'Gets details of a managed source'
  def get(id)
    api = Dscli::API.new
    response = api.source_get(id)
    puts response[:data].to_yaml
  rescue ApiResourceNotFoundError
    puts "Specified managed source '#{id}' was not found. It may have been deleted."
  end

  desc 'start (id)', 'Starts the specified source'
  def start(id)
  	api = Dscli::API.new
    response = api.source_start(id)

    if response[:http][:status] == 200
      puts "Managed source '#{id}' started successfully"
    else
      # TODO: How do we handle a different code?
      response
    end
  rescue ApiResourceNotFoundError
    puts "Specified source '#{id}' not found. It may have been deleted."
  end

  desc 'stop (id)', 'Stops the specified source'
  def stop(id)
  	api = Dscli::API.new
    response = api.source_stop(id)

    if response[:http][:status] == 200
      puts "Managed source '#{id}' stopped successfully"
    else
      # TODO: How do we handle a different code?
      response
    end
  rescue ApiResourceNotFoundError
    puts "Specified source '#{id}' not found. It may have been deleted."
  end

  desc 'delete (id)', 'Deletes a managed source'
  def delete(id)
    api = Dscli::API.new
    response = api.source_delete(id)

    if response[:http][:status] == 204
      puts "Source '#{id}' deleted successfully"
    else
      response
    end
  rescue ApiResourceNotFoundError
    puts "Source '#{id}' not found. It may have been deleted."
  end

  desc 'logs (id)', 'Retrieves the log for a managed source'
  def logs(id = nil)
    api = Dscli::API.new
   	results = api.source_log(id)

	  puts "\nMessage count: #{results[:count]}\n\n"
	  puts ' Time                     | Message                                          '
	  puts '-----------------------------------------------------------------------------------------------------------------'

	  results[:log_entries].each { |s| puts "#{Time.at(s[:event_time]) } | #{ '%-50.50s' % s[:message] }" }
	  puts "\n"

  rescue ApiResourceNotFoundError
    puts "Specified source '#{id}' not found. It may have been deleted."
  end
end
