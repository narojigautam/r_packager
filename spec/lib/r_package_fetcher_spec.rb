require "rails_helper"
require 'webmock/rspec'
require "r_package_fetcher"

RSpec.describe RPackageFetcher, :type => :class do
  let(:r_packager) { RPackageFetcher.new }

  context "#package_filename" do
    before do
      r_packager.package_name = "shape"
      r_packager.version = "1.4.1"
    end

    it "it builds a package filename using package name and version" do
      expect(r_packager.package_filename).to match "shape_1.4.1"
    end
  end

  context "#get_packages_list", allow_net: true do
    let(:package_data) { "Package: A3\nVersion: 0.9.2\nDepends: R (>= 2.15.0), xtable, pbapply\nSuggests: randomForest, e1071\nLicense: GPL (>= 2)\nNeedsCompilation: no\n\nPackage: abc\nVersion: 2.0\nDepends: R (>= 2.10), nnet, quantreg, MASS, locfit\nLicense: GPL (>= 3)\nNeedsCompilation: no" }
    let(:expectation)  { [{"Package"=>" A3", "Version"=>" 0.9.2", "Depends"=>" R (>= 2.15.0), xtable, pbapply",
      "Suggests"=>" randomForest, e1071", "License"=>" GPL (>= 2)", "NeedsCompilation"=>" no"
      }, {"Package"=>" abc", "Version"=>" 2.0", "Depends"=>" R (>= 2.10), nnet, quantreg, MASS, locfit",
        "License"=>" GPL (>= 3)", "NeedsCompilation"=>" no"}] }

    before do
      stub_request(:get, "http://cran.r-project.org/src/contrib/PACKAGES").to_return(:body => package_data, :status => 200)
    end

    it "builds package data into its hash representation" do
      expect(r_packager.get_packages_list).to eq expectation
    end
  end

end
