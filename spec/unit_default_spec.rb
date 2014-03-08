require 'spec_helper'

describe "unit::default" do
  let(:runner) do
    ChefSpec::Runner.new(
      step_into: 'sk_s3_file',
      platform: 'ubuntu',
      version: "13.04",
    )
  end

  let(:test) { runner.converge(described_recipe) }

  let(:fake_headers) do
    {
      "date" => "Fri, 07 Mar 2014 06:10:03 GMT",
      "authorization" => "AWS AKIAIISJV5TZ3FPWU3TA:S2MsiFe3bdh/9bc7emxQUrQXwGE=\n",
    }
  end

  let(:url) { "https://mybucket.s3.amazonaws.com/something/foo.txt" }

  it "calls sk_s3_file" do
    expect(test).to create_sk_s3_file("/tmp/foo.txt")
  end

  it "calls remote_file" do
    expect(test).to create_remote_file("/tmp/foo.txt")
  end

  it "sets owner on the remote_file resource" do
    expect(test).to create_remote_file("/tmp/foo.txt").with(owner: "root")
  end

  it "sets group on the remote_file resource" do
    expect(test).to create_remote_file("/tmp/foo.txt").with(group: "root")
  end

  it "sets mode on the remote_file resource" do
    expect(test).to create_remote_file("/tmp/foo.txt").with(mode: "0644")
  end

  context "when overridding mode to be octal" do
    let(:test) { runner.converge(described_recipe) { runner.find_resource(:sk_s3_file, "/tmp/foo.txt").mode(00644) } }
    it "passes octal to remote_file" do
      expect(test).to create_remote_file("/tmp/foo.txt").with(mode: 00644)
    end
  end

  it "sets path on the remote_file resource" do
    expect(test).to create_remote_file("/tmp/foo.txt").with(path: "/tmp/foo.txt")
  end

  it "sets source on the remote_file resource" do
    expect(test).to create_remote_file("/tmp/foo.txt").with(source: url)
  end

  context "when testing the header generation with a mock object" do
    before do
      mock = double(headers: fake_headers, url: url)
      expect(S3UrlGenerator).to receive(:new).with("mybucket", "/something/foo.txt", "AKIAIISJV5TZ3FPWU3TA", "ABCDEFGHIJKLMNOP1234556/s").and_return(mock)
    end

    it "computes the headers for the remote_file resource" do
      expect(test).to create_remote_file("/tmp/foo.txt").with(headers: fake_headers)
    end

    context "when overriding the date header" do
      let(:test) { runner.converge(described_recipe) { runner.find_resource(:sk_s3_file, "/tmp/foo.txt").headers( "date" => "foo ") } }
      it "passes the date header to remote_file" do
        expect(test).to create_remote_file("/tmp/foo.txt").with(headers: fake_headers.merge( "date" => "foo "))
      end
    end

    context "when overriding the authorization header" do
      let(:test) { runner.converge(described_recipe) { runner.find_resource(:sk_s3_file, "/tmp/foo.txt").headers( "authorization" => "foo ") } }
      it "passes the authorization header to remote_file" do
        expect(test).to create_remote_file("/tmp/foo.txt").with(headers: fake_headers.merge( "authorization" => "foo "))
      end
    end

    context "when adding headers" do
      let(:test) { runner.converge(described_recipe) { runner.find_resource(:sk_s3_file, "/tmp/foo.txt").headers( "x-foobar" => "foo ") } }
      it "merges the header with the computed headers" do
        expect(test).to create_remote_file("/tmp/foo.txt").with(headers: fake_headers.merge( "x-foobar" => "foo "))
      end
    end
  end
end
