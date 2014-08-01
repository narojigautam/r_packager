require 'r_package_fetcher'

# This class takes care of fetching packages and saving them into the DB
#
class RPackageHoarder

  def initialize
    @fetcher = RPackageFetcher.new
  end

  def update_package_list
    packages = @fetcher.get_packages_list
    packages.each do |package_d|
      package = filter_into_package package_d
      r_package = RPackage.find_by name: package[:name]
      r_package ||= RPackage.create package
      r_package.update_version filter_into_version(package)
    end
  end

  def filter_into_version package
    {
      number: package["Version"].try(:strip),
      author: package["Author"].try(:strip),
      released_on: parse_date(package["Date"]),
      dependency: package["Depends"].try(:strip),
      lazy_data: package["LazyData"].try(:strip),
      repository: package["Repository"].try(:strip)
    }
  end

  def filter_into_package package
    {
      name: package["Package"].try(:strip),
      description: package["Description"].try(:strip),
      title: package["Title"].try(:strip),
      date_created: parse_date(package["Packaged"]),
      license: package["License"].try(:strip)
    }
  end

  private

  def parse_date date_str
    Date.parse(date_str) if date_str.present?
  end

end
