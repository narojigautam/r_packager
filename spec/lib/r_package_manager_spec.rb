require "rails_helper"
require "r_package_manager"

RSpec.describe RPackageManager, :type => :class do
  let(:r_packager) { RPackageManager.new }

  context "#build_package_url_for" do
    it "it builds a package url using package name and version" do
      expect(r_packager.build_package_url_for("shape", "1.4.1")).to match "shape-1.4.1"
    end
  end
end
