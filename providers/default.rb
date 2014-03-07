use_inline_resources

def whyrun_supported?
  true
end

action :create do
  do_s3_file(:create)
end

action :create_if_missing do
  do_s3_file(:create_if_missing)
end

action :delete do
  do_s3_file(:delete)
end

action :touch do
  do_s3_file(:touch)
end

def do_s3_file(resource_action)
  remote_path = new_resource.remote_path
  remote_path = "/#{remote_path}" unless remote_path.chars.first == '/'
  s3file = S3UrlGenerator.new(new_resource.bucket, remote_path, new_resource.aws_access_key_id, new_resource.aws_secret_access_key)

  headers = new_resource.headers.nil? ? s3file.headers : s3file.headers.merge(new_resource.headers)

  r = remote_file new_resource.name do
    path                  new_resource.path
    source                s3file.url
    headers               headers
    action                resource_action
  end

  %w{owner group mode checksum use_etag use_etags use_last_modified use_conditional_get backup inherits rights
     atomic_update force_unlink manage_symlink_source sensitive}.each do |method|
    r.send(method, new_resource.send(method)) unless new_resource.send(method).nil?
  end
end
