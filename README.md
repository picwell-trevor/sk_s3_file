# Chef sk_s3_file Cookbook

[![Build Status](https://secure.travis-ci.org/lamont-granquist/sk_s3_file.png?branch=master)](http://travis-ci.org/lamont-granquist/sk_s3_file)

This is based on Brandon Adams' s3_file resource: https://github.com/adamsb6/s3_file

## Description

This resource only requires base ruby, no fog or aws gem dependencies.

This fork of s3_file wraps the Chef >= 11.6.0 remote_file instead of wrapping file

* It streams to disk like remote_file instead of slurping into RAM
* It leverages etags / last-modified headers for idempotency to avoid downloading the file every run, but to download it 
  again if the file changes in s3 (leveraging Chef >= 11.6.0 remote_file support for etags)
* It supports why-run correctly
* It will gain from any future remote_file improvements
* It does depend on CHEF-4042 (adding header attribute in remote_file) and cannot be ported to Chef < 11.6

## Requirements

Chef >= 11.6.0

## Cookbook Depdencies

None

## Resources/Providers

### sk_s3_file

#### Example

This will download the file from S3 using the supplied credentials (example shows using an encrypted data bag which is
a best practice for Hosted Chef).

``` ruby
creds = Chef::EncryptedDataBagItem.load("encrypted", "creds")

sk_s3_file "/tmp/somefile" do
  remote_path "/path/in/s3/to/somefile"
  bucket "mybucket"
  aws_access_key_id creds["ec2_access_key"]
  aws_secret_access_key creds["ec2_secret_key"]
  owner "root"
  group "root"
  mode "0644"
  action :create
end
```

#### Actions

- `:create` - download the file from S3
- `:create_if_missing` - download the file from S3 only if it does not already exista
- `:touch` - behaves like `:create`, but always updates the utime+mtime of the file (resource is always updated)
- `:delete` - remove the file

#### Parameters

* `path` - Path to create the file (NAME ATTRIBUTE)
* `remote_path` - Remote path inside the S3 bucket
* `bucket` - S3 Bucket
* `aws_access_key_id` - AWS access key credentials
* `aws_secret_access_key` - AWS secret key credentials

It also supports all the other parameters of the Chef `remote_file` resource:

* `owner` -
* `group` -
* `mode` -
* `checksum` -
* `backup` -
* `use_etag` -
* `use_last_modified` -
* `atomic_update` -
* `force_unlink` -
* `manage_symlink_source` -
* `inherits` - (WINDOWS ONLY)
* `rights` - (WINDOWS ONLY)

## Recipes

None

## Attributes

None

## Usage

Put `depends sk_s3_file` in your metadata.rb to gain access to the LWRP in your code.

## Contributing

Just open a PR or Issue on GitHub.

DO NOT Submit PRs for Ruby 1.8.7 support.
DO NOT Submit PRs for Chef < 11.6.0 support.

If you want either of those, make a fork and maintain it yourself.

## License and Author

- Author:: Lamont Granquist (<lamont@scriptkiddie.org>)
- Author:: Brandon Adams and other contributors

```text
Copyright:: 2014 Lamont Granquist
Copyright:: 2012-2013 Brandon Adams and other contributors

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

