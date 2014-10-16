actions :install

attribute :path, :kind_of => String, :default => '/etc/shipper'
attribute :package_url,
          :kind_of => String,
          :default => 'https://github.com/dlapiduz/shipper/releases/download/0.0.1/shipper'



def initialize(*args)
  super
  @action = :install
end
