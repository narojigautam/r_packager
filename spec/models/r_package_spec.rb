require 'rails_helper'

RSpec.describe RPackage, :type => :model do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:title) }
end
