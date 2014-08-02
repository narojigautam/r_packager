require 'package_refinement_job'
class RPackage < ActiveRecord::Base
  has_many :versions

  validates_presence_of :name

  def update_version version_data
    version = versions.find_by number: version_data[:number]
    if version
      version.update version_data
    else
      version = Version.create version_data.merge({r_package_id: self.id})
    end
    Resque.enqueue(PackageRefinementJob, version.id)
  end
end
