action :create do
    config_path = "#{new_resource.shipper_path}/#{new_resource.project}.yml"
    service_name = "shipper_#{new_resource.project}"

    template config_path do
      source 'shipper.yml.erb'
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

    template "/etc/init/#{service_name}.conf" do
      source "shipper.upstart.erb"
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
end
