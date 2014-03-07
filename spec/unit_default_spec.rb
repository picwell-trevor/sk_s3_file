require 'spec_helper'

describe "unit::default" do
  let(:test_unit_default) do
    ChefSpec::Runner.new(
      step_into: 'sk_s3_file',
      platform: 'ubuntu',
      version: "13.04",
    ).converge(described_recipe)
  end

  it "calls sk_s3_file" do
    expect(test_unit_default).to create_sk_s3_file("/tmp/foo.txt")
  end

  it "calls remote_file" do
    expect(test_unit_default).to create_remote_file("/tmp/foo.txt")
  end

  it "sets owner on the remote_file resource" do
    expect(test_unit_default).to create_remote_file("/tmp/foo.txt").with(owner: "root")
  end

  it "sets group on the remote_file resource" do
    expect(test_unit_default).to create_remote_file("/tmp/foo.txt").with(group: "root")
  end

  it "sets mode on the remote_file resource" do
    expect(test_unit_default).to create_remote_file("/tmp/foo.txt").with(mode: "0644")
  end

  it "sets path on the remote_file resource" do
    expect(test_unit_default).to create_remote_file("/tmp/foo.txt").with(path: "/tmp/foo.txt")
  end

  it "sets source on the remote_file resource" do
    expect(test_unit_default).to create_remote_file("/tmp/foo.txt").with(source: "https://mybucket.s3.amazonaws.com/something/foo.txt")
  end

  it "computes the headers for the remote_file resource" do
    pending "needs some mocking"
    expect(test_unit_default).to create_remote_file("/tmp/foo.txt").with(headers: nil)
  end
end

