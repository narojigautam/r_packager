# This class takes care of fetching the R Package Files and a list of Packages available
#
class RPackageFetcher
  @@cran_url      = "http://cran.r-project.org/src/contrib/"
  @@package_ext   = ".tar.gz"
  @@packages_info = "PACKAGES"

  attr_accessor :package_name, :version

  # Following method returns a tar.zip file which is temporarily stored in /tmp folder
  # Parameters:
  # name: Required, Name of the package
  # ver : Required, Version of the package that is needed
  #
  def get_package_file(name, ver)
    @package_name, @version = name, ver
    response =  get_request build_package_url
    open(temp_package_file_path, "wb") do |file|
      file.write(response.body)
    end
    File.open(temp_package_file_path)
  end

  # Follwing method returns a list of R Packages in Hash format
  def get_packages_list
    packages_response = get_packages_info
    packages_response = packages_response.split("\n\n")
    packages_response.collect! do |package_data|
      package_data = package_data.split("\n")
      package_data.collect! {|data| data.split(":") }
      Hash[package_data]
    end
  end

  # A method to get a simple file name for any package version
  def package_filename
    "#{@package_name}_#{@version}#{@@package_ext}"
  end

  private

  # URL from where we can get a list of R packages
  def packages_info_url
    @@cran_url + @@packages_info
  end

  def get_request(url)
    HTTParty.get(URI.encode(url))
  end

  def get_packages_info
    response = get_request(packages_info_url)
    response.body
  end

  def build_package_url
    "#{@@cran_url}#{package_filename}"
  end

  def temp_package_file_path
    "/tmp/#{package_filename}"
  end

end
