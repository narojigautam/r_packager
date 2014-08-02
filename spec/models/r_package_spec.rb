require 'rails_helper'

RSpec.describe RPackage, :type => :model do
  it { should validate_presence_of(:name) }

  context "#update_version" do
    let!(:r_pack) { RPackage.create name: "test package", title: "test title" }
    let(:version_data) { {number: "1.1.1", author: "Gautam Naroji", released_on: Date.today} }

    it "creates a version of the package if it already doesnt exist" do
      expect(r_pack.versions.count).to eq 0
      r_pack.update_version version_data
      expect(r_pack.versions.reload.count).to eq 1
    end

    it "updates a version of the package if it already exists" do
      Version.create({r_package_id: r_pack.id, number: "1.1.1"})
      expect(r_pack.versions.reload.first.author).to be_nil
      expect(r_pack.versions.count).to eq 1
      r_pack.update_version version_data
      expect(r_pack.versions.reload.first.author).to eq "Gautam Naroji"
      expect(r_pack.versions.count).to eq 1
    end
  end
end
