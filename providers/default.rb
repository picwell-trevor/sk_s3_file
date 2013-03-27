
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
  s3file = S3UrlGenerator.new(new_resource.bucket, new_resource.remote_path, new_resource.aws_access_key_id, new_resource.aws_secret_access_key)

  remote_file new_resource.name do
    path new_resource.path
    checksum new_resource.checksum
    backup new_resource.backup
    use_etag new_resource.use_etag
    use_last_modified new_resource.use_last_modified
    source s3file.url
    headers s3file.headers
    owner new_resource.owner
    group new_resource.group
    mode new_resource.mode
    action resource_action
  end
end
