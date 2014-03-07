require 'spec_helper'

describe "unit::default" do
  let(:test_unit_default) do
    ChefSpec::Runner.new(
      step_into: 'sk_s3_file',
      platform: 'ubuntu',
      version: "13.04",
    ).converge(described_recipe)
  end

  it "converges" do
    expect(test_unit_default).to create_sk_s3_file("/tmp/foo.txt")
  end
end
