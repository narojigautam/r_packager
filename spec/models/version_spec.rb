require 'rails_helper'

RSpec.describe Version, :type => :model do
  it { should belong_to(:r_package) }
  it { should validate_presence_of(:number) }
  it { should validate_presence_of(:r_package) }

end
