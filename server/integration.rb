require 'timeout'

if $0 == __FILE__ then
  require to_absolute_path('./conf_common.rb')
end

class Jira

	def initialize
		@issue_resource = RestClient::Resource.new("#{JIRA_REST_BASE_PATH}/issue/", :user => JIRA_USERNAME, :password => JIRA_PASSWORD)
	end
	
	def get(issue_key)
		@issue_resource[issue_key].get
  rescue => err
      message = "Unable to get issue #{issue_key} from #{JIRA_REST_BASE_PATH}!"
			$logger.error(err)
			$logger.error(message)
      message
	end
	
	def post(issue_content)
		@issue_resource.post issue_content, :content_type => 'application/json'
		rescue => err
			$logger.error(err)
			$logger.error("Unable to create new issue with content #{issue_content} in #{JIRA_REST_BASE_PATH}!")
      nil
	end
	
	def format_issue_content(project, type, summary, priority, description, version)
		fields = {
        :project => {
            :key => project
        },
        :priority => {
            :name => priority
        },
        :summary => summary,
        :description => description,
        :issuetype => {
            :name => type
        },
    }
    fields[:customfield_10711] = {:value => version} if version
    {:fields => fields}.to_json
  end

  def attach(path_to_file, issue_key)
    #@issue_resource[issue_key]['attachments'].post :file => File.new(path_to_file, 'rb'), :content_type => 'X-Atlassian-Token: nocheck'
    `curl -D- -u #{JIRA_USERNAME}:#{JIRA_PASSWORD} -X POST -H \"X-Atlassian-Token: nocheck\" -F \"file=@#{path_to_file}\" #{JIRA_REST_BASE_PATH}/issue/#{issue_key}/attachments`
    raise if $?.exitstatus != 0
    rescue => err
      $logger.error(err)
      $logger.error("Unable to attach file to #{issue_key} at #{JIRA_REST_BASE_PATH}!")
    nil
  end
end

class Svn
	
	attr_accessor :revision_from, :revision_to, :branch

	def format_svn_log(svn_log)
		# Substitutes JIRA issue keys with links and adds <BR> tags at the 
		#	end of lines. Also substitutes paths to files with links to FishEye
		
		if svn_log.respond_to?('scan') then 
			# create links from JIRA ids
			match = svn_log.scan(/[A-Z]{2,}-\d{1,}/).uniq
			match.each do | m |
				svn_log = svn_log.gsub(m, "<A HREF=\"#{JIRA_BASE_PATH}#{m}\">#{m}</A>")
			end
			
			# create links from file paths
			match = svn_log.scan(/\/wms\/\S*/).uniq
			match.each do | m |
				svn_log = svn_log.gsub(m, "<A HREF=\"#{FISHEYE_BASE_PATH}#{m}\">#{m}</A>")
			end
			
			# replace Subversion M, A, D abbreviations with words
			svn_log = svn_log.gsub(/ M /, '<B>MODIFIED: </B>')
			svn_log = svn_log.gsub(/ A /, '<B>ADDED: </B>')
			svn_log = svn_log.gsub(/ D /, '<B>DELETED: </B>')
			svn_log = svn_log.gsub(/\n/,' <BR> ')
		else
			'No changes'
		end
	end

	def svn_log
		
		# Fetches changes between revisions from Subversion.
		
		if (@revision_from and @revision_to and @revision_from != @revision_to) then
			command = "svn log --verbose --incremental --revision #{@revision_to}:#{@revision_from} #{SVN_BASE_PATH}/#{@branch}"
			$logger.info("Command to call SVN: #{command}")
			if @revision_from.match('^\d{1,6}') && (@revision_to.match('^\d{1,6}') || @revision_to == 'HEAD') then
				begin
					Timeout::timeout(SVN_TIME_OUT) { 
						begin
							@svn_log = `#{command}`
							raise if @svn_log.length < 1 
						rescue
							message = "<div class='failure'>ERROR:</div>Something went wrong with calling Subversion."
							$logger.error(message)
							@svn_log = message
						end
					}
				rescue => err 					
					$logger.error("svn log command took more than #{SVN_TIME_OUT} seconds to execute. Check if #{SVN_BASE_PATH} is accessible or consider changing SVN_TIME_OUT property in conf_common.rb")
					$logger.error(err)
					@svn_log = "<div class='failure'>ERROR:</div> svn log took longer than expected. Please contact aldministrator to check application log."
				end
			end
		end
		format_svn_log(@svn_log)
	end
end
