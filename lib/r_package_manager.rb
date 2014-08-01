class RPackageManager
  @@cran_url      = "http://cran.r-project.org/src/contrib/"
  @@package_ext   = ".tar.gz"
  @@packages_info = "Packages"

  def packages_info_url
    @@cran_url + @@packages_info
  end

  def build_package_url_for(package_name, version)
    "#{@@cran_url}#{package_name}-#{version}#{@@package_ext}"
  end

end
