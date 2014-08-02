class HomeController < ApplicationController
  def index
    @r_packages = RPackage.limit(50)
  end
end
