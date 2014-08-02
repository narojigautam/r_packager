class Version < ActiveRecord::Base
  belongs_to :r_package

  validates_presence_of :r_package_id, :number

  def package_name
    r_package.name
  end
end
