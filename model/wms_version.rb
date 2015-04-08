class WmsVersion
  include DataMapper::Resource
  property :name, String,										:key => true
  property :jira_name, String
  property :responsible, String
  property :protection_level, String
  property :fat_deploy_project_id, String
  property :fat_deploy_buildtype_id, String
  property :svn_branch, String
  property :watchers, Object
  property :max_age, Integer

  has n, :environments

  def save_configuration
    WmsVersion.auto_migrate!
    VERSIONS.values.each do | definition |
      if not definition[:name].match(/\s/) then
        WmsVersion.create(:name => definition[:name]).update(definition)
      else
        raise "Version name \"#{definition[:name]}\" contains whitespaces!"
      end
    end
  end
end