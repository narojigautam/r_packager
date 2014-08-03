# Details of an Author of any R Package Version
# An Author can have many Versions
# A RPackage can have many Authors through its Versions
#
class Author < ActiveRecord::Base
  has_many :version_committers
  has_many :versions, through: :version_committers
  has_many :r_packages, through: :versions

  validates_presence_of :email

  def identity
    "#{name}, (#{email})"
  end

end
