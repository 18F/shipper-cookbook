action :create do
    Chef::Log.info("Creating #{@new_resource}")  unless exists?

    config_path = "#{new_resource.shipper_path}/#{new_resource.project}.yml"
    service_name = "shipper_#{new_resource.project}"

    c = template config_path do
      source 'shipper.yml.erb'
      cookbook 'shipper'
      variables(
        repo: new_resource.repository,
        environment: new_resource.environment,
        app_path: new_resource.app_path,
        server_id: new_resource.server_id || Digest::SHA1.hexdigest(node['ipaddress']),
        before_symlink: new_resource.before_symlink,
        after_symlink: new_resource.after_symlink,
        shared_files: new_resource.shared_files
      )
    end

    s = template "/etc/init/#{service_name}.conf" do
      source "shipper.upstart.erb"
      cookbook 'shipper'
      variables(
        github_key: new_resource.github_key,
        config_path: config_path,
        app_user: new_resource.app_user,
        app_path: new_resource.app_path,
        shipper_path: new_resource.shipper_path
      )
      owner  "root"
      group  "root"
      mode   "0644"
    end

    service service_name do
      provider Chef::Provider::Service::Upstart
      action   [:enable, :start]
    end

    new_resource.updated_by_last_action(c.updated_by_last_action? || s.updated_by_last_action?)
end

action :delete do
  if exists?
    if ::File.writable?(@new_resource.yml_path)
      service_name = "shipper_#{@new_resource.project}"

      Chef::Log.info("Deleting #{@new_resource}")
      ::File.delete(@new_resource.yml_path)
      ::File.delete("/etc/init/#{service_name}.conf")

      service service_name do
        provider Chef::Provider::Service::Upstart
        action   [:disable, :stop]
      end

      new_resource.updated_by_last_action(true)
    else
      raise "Cannot delete #{@new_resource}!"
    end
  end
end

def load_current_resource
  @current_resource = Chef::Resource::ShipperConfig.new(@new_resource.name)
  @current_resource.project(@new_resource.project)
  @current_resource
end

private
  def exists?
    ::File.exist?(@current_resource.yml_path)
  end
