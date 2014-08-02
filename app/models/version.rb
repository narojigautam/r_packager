# The Version class mainatians R Package Versions. It also assocites with Authors and Maintainers
# A Version can have only one Author and many Maintainers.
#
class Version < ActiveRecord::Base
  belongs_to :r_package
  has_one :author_committer, -> { where "version_committers.role in ('author', 'all')" },
    class_name: "VersionCommitter"
  has_one :author, through: :author_committer
  has_many :maintainer_committers, -> { where "version_committers.role in ('maintainer', 'all')" },
    class_name: "VersionCommitter"
  has_many :maintainers, through: :maintainer_committers

  validates_presence_of :r_package_id, :number

  def package_name
    r_package.name
  end
end
