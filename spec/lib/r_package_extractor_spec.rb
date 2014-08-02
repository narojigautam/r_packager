require "rails_helper"
require "r_package_extractor"

RSpec.describe RPackageExtractor, :type => :class do
  let(:r_extractor) { RPackageExtractor.new("snarf", "1.0.1") }

  context "#parse_package_description" do
    let(:response_desc) { "Package: awesomeness\nAuthor: Gautam Naroji <narojigautam@gmail.com>" }
    let(:expectation)   { {"Package" => " awesomeness", "Author" => " Gautam Naroji <narojigautam@gmail.com>" } }

    it "parses the package description file into a hash" do
      r_extractor.package_desc = response_desc
      r_extractor.parse_package_description
      expect(r_extractor.package_desc).to eq expectation
    end
  end
end
