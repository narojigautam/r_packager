require 'rubygems/package'
require 'zlib'
require 'r_package_fetcher'
require 'filter_package_data'

# This class takes care of handling .tar.gz files and extracting Package info
#
class RPackageExtractor
  include FilterPackageData

  attr_accessor :package_hash, :version_hash

  def initialize(package, ver)
    @package_name, @version = package, ver
    @fetcher = RPackageFetcher.new
    @package_hash, @version_hash = {}, {}
    download_and_extract_package
    @package_desc = ""
  end

  # Following method downloads the package and caches the description as an instance variable
  #
  def download_and_extract_package
    @fetcher.get_package_file(@package_name, @version)
    Gem::Package::TarReader.new( Zlib::GzipReader.open @fetcher.temp_package_file_path ) do |tar|
      tar.each do |entry|
        next unless entry.file? and entry.full_name.match("DESCRIPTION")
        @package_desc = entry.read
      end
    end
    FileUtils.rm_rf @fetcher.temp_package_file_path
    @package_desc
  end

  # This method calls the download package method and stores result as usable package data
  # We initialize Package and Version hashs so that they can be easily used to update db
  #
  def set_package_info
    download_and_extract_package
    @package_hash = filter_into_package @package_desc
    @version_hash = filter_into_version @package_desc
  end
end