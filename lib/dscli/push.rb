class Push < Thor

  desc 'list [page]', 'Lists all current subscriptions'
  def list(page = 1)
    api = Dscli::API.new
    results = api.push_list(page)

    puts "\nTotal Subscriptions: #{results[:subscriptions].count}\n\n"
    if results[:subscriptions].count > 0
      puts 'ID                               | Name                 | Output Type | Created                    | Status   '
      puts '--------------------------------------------------------------------------------------------------------------'

      results[:subscriptions].each { |s| puts "#{s[:id]} | #{ '%-20.20s' % s[:name] } | #{ '%-11.11s' % s[:output_type] } |  #{Time.at(s[:created_at])} | #{s[:status]}" }
      puts "\n"
    end
  end

  desc 'get (id)', 'Gets details of a push subscription'
  def get(id)
    begin
      api = Dscli::API.new
      response = api.push_get(id)
      puts response[:data].to_yaml
    rescue ApiResourceNotFoundError => e
      puts "Specified push subscription '#{id}' not found. It may have already been deleted."
    end
  end

  desc 'stop (id)', 'Stops a push subscription'
  def stop(id)
    begin
      api = Dscli::API.new
      api.push_stop(id)
    rescue ApiResourceNotFoundError => e
      puts "Specified push subscription '#{id}' not found. It may have been deleted."
    rescue BadRequestError => e
      puts "Specified push subscription '#{id}' could not be stopped. It may have already been stopped."
    end
  end

  desc 'delete (id)', 'Deletes a push subscription'
  def delete(id)
    api = Dscli::API.new

    begin
      response = api.push_delete(id)

      if response[:http][:status] == 204
        puts "Push subscription #{id} deleted successfully"
      else
        # TODO: How do we handle a different code?
        response
      end
    rescue ApiResourceNotFoundError => e
      puts "Specified push subscription '#{id}' not found. It may have already been deleted."
    end
  end

  desc 'log [id]', 'Retrieves logs for all subscriptions (or for the subscription ID supplied)'
  def log(id = nil)
    api = Dscli::API.new

    begin
      results = api.push_log(id)

      puts "\nMessage count: #{results[:count]}\n\n"

      if results[:count] > 0
        puts ' Time                     | Subscription ID                  | Message                                          '
        puts '-----------------------------------------------------------------------------------------------------------------'

        results[:log_entries].each { |s| puts "#{Time.at(s[:request_time]) } | #{s[:subscription_id]} | #{ '%-50.50s' % s[:message] }" }
        puts "\n"
      end
    rescue ApiResourceNotFoundError => e
      puts "Specified push subscription '#{id}' not found. It may have been deleted."
    end
  end

  desc 'pause (id)', 'Pauses a push subscription'
  def pause(id)
    api = Dscli::API.new

    begin
      response = api.push_pause(id)

      if response[:http][:status] == 204
        puts "Push subscription #{id} paused successfully"
      else
        response
      end
    rescue ApiResourceNotFoundError => e
      puts "Specified push subscription '#{id}' not found."
    end
  end

  desc 'resume (id)', 'Resumes a paused push subscription'
  def resume(id)
    api = Dscli::API.new

    begin
      response = api.push_resume(id)

      if response[:http][:status] == 204
        puts "Push subscription #{id} resumed successfully"
      else
        response
      end
    rescue ApiResourceNotFoundError => e
      puts "Specified push subscription '#{id}' not found."
    end
  end

end