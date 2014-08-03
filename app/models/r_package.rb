require 'package_refinement_job'
class RPackage < ActiveRecord::Base
  has_many :versions
  has_many :authors, through: :versions
  has_many :maintainers, through: :versions

  validates_presence_of :name

  def update_version version_data
    version = versions.find_by number: version_data[:number]
    if version
      version.update version_data
    else
      version = Version.create version_data.merge({r_package_id: self.id})
    end
    # Unhooking resque to not pay for heroku workers
    # Resque.enqueue(PackageRefinementJob, version.id)
    PackageRefinementJob.perform(version.id)
  end
end
