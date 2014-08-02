require "rails_helper"
require "r_package_extractor"
require "package_refinement_job"
RSpec.describe PackageRefinementJob, :type => :class do
  context "#perform" do
    let(:package)      { create(:r_package, name: "shape") }
    let(:version)      { create(:version, number: "1.4.1", r_package: package) }
    let(:version_hash) { {dependency: "Halleluja"} }
    let(:package_hash) { {description: "Functions for plotting graphical shapes"} }
    let(:author_hash)  { {email: "snar@f.com", name: "Snarf Snarf"} }
    let(:maint_hash)   { {email: "pop@at.com", name: "Pop At"} }

    before do
      RPackageExtractor.any_instance.stub(:set_package_info).and_return("")
      RPackageExtractor.any_instance.stub(:version_hash).and_return(version_hash)
      RPackageExtractor.any_instance.stub(:package_hash).and_return(package_hash)
      RPackageExtractor.any_instance.stub(:author_hash).and_return(author_hash)
      RPackageExtractor.any_instance.stub(:maintainer_hash).and_return(maint_hash)

      PackageRefinementJob.perform(version.id)
    end

    it "updates the version with more details" do
      expect(version.reload.dependency).to eq("Halleluja")
    end

    it "updates the package with more details" do
      expect(package.reload.description).to eq("Functions for plotting graphical shapes")
    end

    it "create an author if it does not exist" do
      expect(version.reload.author.email).to eq "snar@f.com"
      expect(version.author.name).to eq "Snarf Snarf"
    end

    it "create a maintainer if it does not exist" do
      expect(version.reload.maintainers.first.email).to eq "pop@at.com"
      expect(version.maintainers.first.name).to eq "Pop At"
    end
  end
end
