if defined?(ChefSpec)
  def create_sk_s3_file(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:sk_s3_file, :create, resource_name)
  end
end
