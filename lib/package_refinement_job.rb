require 'r_package_extractor'

class PackageRefinementJob
  @queue = :r_packages

  # Method to update Package ad Version with details from Description file of a package
  # It also creates an Author for the version, is it doesnt already have one
  #
  def self.perform(version_id)
    version = Version.find(version_id)
    package = version.r_package
    package_extractor = RPackageExtractor.new(version.package_name, version.number)
    package_extractor.set_package_info
    version.update(package_extractor.version_hash)
    package.update(package_extractor.package_hash)
    author_hash = package_extractor.author_hash
    return unless author_hash[:email].present?
    author = Author.find_or_create_by email: author_hash[:email]
    author.update(author_hash)
  end
end
