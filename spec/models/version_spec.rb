require 'rails_helper'

RSpec.describe Version, :type => :model do
  it { should have_one(:author) }
  it { should have_many(:maintainers) }
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

  context "a version can be authored and maintained" do
    let(:author)       { create(:author) }
    let(:maintainer)   { create(:maintainer) }
    let(:version)      { create(:version) }
    let(:version2)     { create(:version) }
    let(:version3)     { create(:version) }
    let!(:a_committer) { create(:author_committer, author: author, version: version) }
    let!(:m_committer) { create(:maintainer_committer, maintainer: maintainer, version: version2) }
    let!(:owner)       { create(:owner_committer, author_id: author.id, version: version3) }

    it "returns the correct author of a version" do
      expect(version.author).to eq author
    end

    it "returns the correct maintainer of a version" do
      expect(version2.maintainers).to include(maintainer)
      expect(version2.maintainers.count).to eq 1
    end

    it "lets an author be both author and mainatainer of the version" do
      expect(version3.author).to eq author
      expect(version3.maintainers).to include(author)
      expect(version3.maintainers.count).to eq 1
    end

  end

end
