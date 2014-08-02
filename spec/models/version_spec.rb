require 'rails_helper'

RSpec.describe Version, :type => :model do
  it { should belong_to(:r_package) }
  it { should validate_presence_of(:number) }
  it { should validate_presence_of(:r_package_id) }

  describe "#package_name" do
    let(:pack) { RPackage.create name: "gautam" }
    let(:vers) { Version.create number: "123", r_package_id: pack.id }
    it "returns the name of the package to which the version belongs" do
      expect(vers.package_name).to eq "gautam"
    end
  end

end
