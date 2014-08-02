require 'r_package_extractor'

class PackageRefinementJob
  @queue = :r_packages

  def self.perform(version_id)
    version = Version.find(version_id)
    package = version.package
    package_extractor = RPackageExtractor.new(version.package_name, version.number)
    package_hash = package_extractor.extract_package
    version_hash = package_extractor.extract_version
    version.update(version_hash)
    package.update(package_hash)
  end
end
