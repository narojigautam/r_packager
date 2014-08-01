class RPackage < ActiveRecord::Base
  has_many :versions

  validates_presence_of :name, :title
end
