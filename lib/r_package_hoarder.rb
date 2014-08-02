require 'r_package_fetcher'
require 'filter_package_data'

# This class takes care of fetching packages and saving them into the DB
#
class RPackageHoarder
  include FilterPackageData

  def initialize
    @fetcher = RPackageFetcher.new
    @redis = Redis.new
  end

  def package_updates_available?
    last_import_hash = @redis.get "last-package-import-hash"
    @fetcher.new_import_hash != last_import_hash
  end

  def update_package_list
    return unless package_updates_available?
    packages = @fetcher.get_packages_list
    packages.each do |package_d|
      package = filter_into_package package_d
      r_package = RPackage.find_by name: package[:name]
      if r_package.present?
        r_package.update package
      else
        r_package = RPackage.create package
      end
      r_package.update_version filter_into_version(package_d)
    end
    @redis.set "last-package-import-hash", @fetcher.new_import_hash
  end

  def force_update_package_list
    @redis.set "last-package-import-hash", "failedhash"
    update_package_list
  end

end
