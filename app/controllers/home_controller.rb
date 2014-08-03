class HomeController < ApplicationController
  def index
    @r_packages = RPackage.first(50)
  end
end
