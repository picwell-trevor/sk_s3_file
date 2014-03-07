
sk_s3_file '/tmp/foo.txt' do
  remote_path "/something/foo.txt"
  bucket "mybucket"
  aws_access_key_id "AKIAIISJV5TZ3FPWU3TA"
  aws_secret_access_key "ABCDEFGHIJKLMNOP1234556/s"
  owner "root"
  group "root"
  mode "0644"
  action :create
end
