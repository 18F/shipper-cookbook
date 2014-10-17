action :install do
    directory new_resource.path

    remote_file "#{new_resource.path}/shipper" do
      source new_resource.package_url
      mode   "0755"
    end

    new_resource.updated_by_last_action(true)
end
