actions :create, :delete

attribute :project, :kind_of => String, :name_attribute => true
attribute :repository, :kind_of => String
attribute :environment, :kind_of => String, :default => 'production'
attribute :app_path, :kind_of => String
attribute :app_user, :kind_of => String
attribute :server_id, :kind_of => String
attribute :github_key, :kind_of => String
attribute :shared_files, :kind_of => Hash, :default => {}
attribute :before_symlink, :kind_of => Array, :default => []
attribute :after_symlink, :kind_of => Array, :default => []

attribute :shipper_path, :kind_of => String, :default => '/etc/shipper'

def initialize(*args)
  super
  @action = :create
end
