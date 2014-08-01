require "rails_helper"
require 'webmock/rspec'
require "r_package_hoarder"
require "r_package_fetcher"

RSpec.describe RPackageHoarder, :type => :class do
  let(:r_hoarder) { RPackageHoarder.new }

  context "#update_package_list" do
    let(:sample_packages_list) { [{"Package"=>" A3", "Version"=>" 0.9.2", "Depends"=>" R (>= 2.15.0), xtable, pbapply",
      "Suggests"=>" randomForest, e1071", "License"=>" GPL (>= 2)", "NeedsCompilation"=>" no"
      }, {"Package"=>" abc", "Version"=>" 2.0", "Depends"=>" R (>= 2.10), nnet, quantreg, MASS, locfit",
        "License"=>" GPL (>= 3)", "NeedsCompilation"=>" no"}] }

    before do
      RPackageFetcher.any_instance.stub(:get_packages_list). and_return(sample_packages_list)
    end

    it "fetches packages and stores them in RPackage model" do
      r_hoarder.update_package_list
      expect(RPackage.pluck(:name)).to eq ["A3", "abc"]
    end
  end
end
