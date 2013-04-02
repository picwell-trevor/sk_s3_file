actions :create, :create_if_missing, :touch, :delete
attribute :path, :kind_of => String, :name_attribute => true
attribute :remote_path, :kind_of => String
attribute :bucket, :kind_of => String
attribute :aws_access_key_id, :kind_of => String
attribute :aws_secret_access_key, :kind_of => String
attribute :owner, :regex => Chef::Config[:user_valid_regex]
attribute :group, :regex => Chef::Config[:group_valid_regex]
attribute :mode, :kind_of => [String, NilClass], :default => nil
attribute :checksum, :kind_of => [String, NilClass], :default => nil
attribute :backup, :kind_of => [Integer, FalseClass], :default => 5
attribute :use_etag, :kind_of => [TrueClass, FalseClass], :default => true
attribute :use_last_modified, :kind_of => [TrueClass, FalseClass], :default => true

def initialize(*args)
  version = Chef::Version.new(Chef::VERSION[/^(\d+\.\d+\.\d+)/, 1])
  if version.major < 10 # || ( version.major == 11 && version.minor < 6 )
    raise "s3_file provider is not supported on Chef <= 11.6.x"
  end
  super
  @action = :create
  @path = name
end
