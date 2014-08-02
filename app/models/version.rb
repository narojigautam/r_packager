class Version < ActiveRecord::Base
  belongs_to :r_package

  validates_presence_of :r_package_id, :number
end
