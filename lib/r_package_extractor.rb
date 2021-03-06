require 'rubygems/package'
require 'zlib'
require 'r_package_fetcher'
require 'filter_package_data'

# This class takes care of handling .tar.gz files and extracting Package info
#
class RPackageExtractor
  include FilterPackageData

  attr_accessor :package_hash, :version_hash, :author_hash, :package_desc, :maintainer_hash

  def initialize(package, ver)
    @package_name, @version = package, ver
    @fetcher = RPackageFetcher.new
    @package_hash, @version_hash, @author_hash, @maintainer_hash = {}, {}, {}, {}
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
  end

  # This method calls the download package method and stores result as usable package data
  # We initialize Package and Version hashs so that they can be easily used to update db
  #
  def set_package_info
    download_and_extract_package
    parse_package_description
    @package_hash = filter_into_package @package_desc
    @version_hash = filter_into_version @package_desc
    @author_hash  = filter_into_author  @package_desc["Author"]
    @maintainer_hash = filter_into_author  @package_desc["Maintainer"]
  end

  # This method takes response from reading the description file and parses it into a hash
  #
  def parse_package_description
    @package_desc = @package_desc.split("\n")
    # DESCRIPTION file sometimes has extra \n which creates issues in parsing
    # following block will take care of those
    @package_desc.each_index do |i|
      next if @package_desc[i].match(":")
      @package_desc[i-1] += @package_desc[i]
      @package_desc.delete_at(i)
    end
    @package_desc.collect! do |package_data|
      package_data = package_data.split(":")
    end
    @package_desc = parse_into_hash(@package_desc)
  end

  private

  def parse_into_hash array
    response = {}
    array.each do |key_val|
      response[key_val[0]] = key_val[1]
    end
    response
  end
end