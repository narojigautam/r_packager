class RPackage < ActiveRecord::Base
  has_many :versions

  validates_presence_of :name, :title

  def update_version version_data
    version = versions.find_by number: version_data[:number]
    if version
      version.update version_data
    else
      Version.create version_data.merge({r_package_id: self.id})
    end
  end
end
