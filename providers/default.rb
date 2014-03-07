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

  remote_file new_resource.name do
     path                  new_resource.path
     source                s3file.url
     headers               headers
     owner                 new_resource.owner unless new_resource.owner.nil?
     group                 new_resource.group unless new_resource.group.nil?
     mode                  new_resource.mode unless new_resource.mode.nil?
     checksum              new_resource.checksum unless new_resource.checksum.nil?
     use_etag              new_resource.use_etag unless new_resource.use_etag.nil?
     use_etags             new_resource.use_etags unless new_resource.use_etags.nil?
     use_last_modified     new_resource.use_last_modified unless new_resource.use_last_modified.nil?
     use_conditional_get   new_resource.use_conditional_get unless new_resource.use_conditional_get.nil?
     backup                new_resource.backup unless new_resource.backup.nil?
     inherits              new_resource.inherits unless new_resource.inherits.nil?
     inherits              new_resource.rights unless new_resource.rights.nil?
     atomic_update         new_resource.atomic_update unless new_resource.atomic_update.nil?
     force_unlink          new_resource.force_unlink unless new_resource.force_unlink.nil?
     manage_symlink_source new_resource.manage_symlink_source unless new_resource.manage_symlink_source.nil?
     sensitive             new_resource.sensitive unless new_resource.sensitive.nil?
     action                resource_action
  end
end
