require 'rails_helper'

RSpec.describe Author, :type => :model do
  it { should have_many(:r_packages) }
  it { should have_many(:versions) }
  it { should validate_presence_of(:email) }
end
