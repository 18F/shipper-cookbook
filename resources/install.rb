actions :install

attribute :path, :kind_of => String, :default => '/etc/shipper'
attribute :package_url,
          :kind_of => String,
          :default => 'https://github.com/18f/shipper/releases/download/v0.1.0/shipper'



def initialize(*args)
  super
  @action = :install
end
