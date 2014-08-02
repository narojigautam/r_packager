require "r_package_hoarder"

namespace :r_packages do
  desc "A task that will run every day at 12pm to index any new package that appeared during the day"
  task daily_import: :environment do
    r_package_hoarder = RPackageHoarder.new
    p "Fetching updates for R Packages"
    r_package_hoarder.update_package_list
    p "R Packages updated."
  end
end
