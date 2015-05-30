require 'net/ssh'
require 'net/http'
require 'timeout'

class Stage
  SVN_BASE_PATH = 'https://github.com/dinkotom/wmstools/trunk'

  attr_writer :name,
              :username,
              :password,
              :port,
              :control_port,
              :change_log_file,
              :rack_file

  attr_accessor :path,
                :hostname,
                :quota

  def start
    p 'Starting...'
    command = "cd #{@path}; puma --port #{@port} --control tcp://0.0.0.0:#{@control_port} --control-token SalvatorDali01 #{@rack_file} -d"
    p "Running command: '#{command}'"
    ssh_exec(command)
  end

  def restart
    if running?
      p 'Restarting...'
      http_get("http://#{@hostname}:#{@control_port}/restart?token=SalvatorDali01")
    else
      start
    end
  end

  def deploy
    p 'Deploying...'
    if @path =~ /^\/\w+\/\w+/
      ssh_exec("rm -rf #{@path}")
      ssh_exec("svn export #{SVN_BASE_PATH} #{@path}")
      write_deployment_timestamp
    else
      raise "Wrong path: #{@path}"
    end
  end

  def bundle_install
    ssh_exec("cd #{@path}; bundle install")
  end

  def modify_config(file, key, new_value)
    p "Modifying #{file} ..."
    ssh_exec("sed -i \"s/\\(#{key} *= *\\).*/\\1#{new_value}/\" #{file}")
    raise unless ssh_exec("grep #{key} #{file}").include?(new_value)
    p "Modified. New line in #{file}: #{key} = #{new_value} ..."
  end

  def rollback_running_execs
    delay = 5
    p "Sleeping #{delay} seconds before attempting to rollback running and preparing executions..."
    sleep delay
    p 'Attempting to rollback running and preparing executions...'
      response = Net::HTTP.get(@hostname, '/rollback_running_executions', @port)
    if response == 'OK'
      p 'Running and preparing executions rolled back successfully'
    else
      p 'Failed to rollback running and preparing executions'
      raise
    end
  end

  private

  def write_deployment_timestamp
    if @change_log_file
      ssh_exec("echo -e \"\n\n<BR><BR>Deployed on `date`\" >> #{@change_log_file}")
    end
  end

  def http_get(url)
    Timeout::timeout(5) do
      Net::HTTP.get_response(URI.parse(url))
    end
  rescue
    return false
  end

  def running?
    p 'Trying to find out if server is up...'
    response = http_get("http://#{@hostname}:#{@control_port}/stats?token=SalvatorDali01")
    if response && response.code == '200'
      p 'Server is up.'
      return true
    else
      p 'Server is down.'
      return false
    end
  end

  def ssh_exec(command)
    output = String.new
    Net::SSH.start(@hostname, @username, :password => @password) do |ssh|
      ssh.open_channel do |channel|
        channel.exec(command) do |ch, success|
          unless success
            raise "FAILED: couldn't execute command (ssh.channel.exec)"
          end
          channel.on_data do |ch, data|
            output += data
            puts "Stdout: #{data}\n"
          end
          channel.on_extended_data do |ch, type, data|
            puts "Stderr: #{data}\n"
          end
          channel.on_request("exit-status") do |ch, data|
            raise unless data.read_long.to_i == 0
          end
        end
      end
    end
    output
  end

end
