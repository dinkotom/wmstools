require 'net/ssh'
require 'net/http'
require 'timeout'

class Stage
  SVN_BASE_PATH = 'http://192.176.148.85/svnrepo/tool/WMSTools/trunk'

  attr_writer :name,
              :username,
              :password,
              :port,
              :control_port,
              :change_log_file,
              :rack_file

  attr_accessor :deploy_items,
                :path,
                :hostname

  def start
    p 'Starting...'
    command = "cd #{@path}; screen -d -m -S wmsTools_#{@name} puma --port #{@port} --control tcp://0.0.0.0:#{@control_port} --control-token SalvatorDali01 #{@rack_file}"
    p "Running command: '#{command}'"
    ssh_exec(command)
    check_screen_created("wmsTools_#{@name}")
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
      ssh_exec("mkdir -p #{@path}; rm -rf #{@path}/*")
      @deploy_items.each { |item| ssh_exec("svn export #{SVN_BASE_PATH}/#{item} #{@path}/#{item}") }
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
    ssh_exec("sed -i \"s/\\(#{key} *= *\\).*/\\1'#{new_value}'/\" #{file}")
    raise unless ssh_exec("grep #{key} #{file}").include?(new_value)
    p "Modified. New line in #{file}: #{key} = #{new_value} ..."
  end

  def prepare_agents_for_shutdown
    p 'Attempting to prepare agents for shutdown...'
    response = Net::HTTP.get(@hostname, '/prepare_for_agents_shutdown')
    if response == 'OK'
      p 'Agents successfully prepared for shutdown'
    else
      p 'Failed to prepare agents for shutdown'
      raise
    end
  end

  private

  def check_screen_created(name)
    ssh_exec("screen -S #{name} -Q select")
  end

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