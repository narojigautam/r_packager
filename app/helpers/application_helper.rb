require "r_package_fetcher"
module ApplicationHelper
  def download_path_for(r_package, version)
    RPackageFetcher.new.get_package_url_for r_package, version
  end
end
