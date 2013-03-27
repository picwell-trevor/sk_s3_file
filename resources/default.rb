actions :create
attribute :path, :kind_of => String, :name_attribute => true
attribute :remote_path, :kind_of => String
attribute :bucket, :kind_of => String
attribute :aws_access_key_id, :kind_of => String
attribute :aws_secret_access_key, :kind_of => String
attribute :owner, :kind_of => [String, NilClass], :default => nil
attribute :group, :kind_of => [String, NilClass], :default => nil
attribute :mode, :kind_of => [String, NilClass], :default => nil
attribute :checksum, :kind_of => [String, NilClass], :default => nil
attribute :backup, :kind_of => [Integer, FalseClass], :default => 5
attribute :use_etag, :kind_of => [TrueClass, FalseClass], :default => true
attribute :use_last_modified, :kind_of => [TrueClass, FalseClass], :default => true

def initialize(*args)
  super
  @action = :create
end
