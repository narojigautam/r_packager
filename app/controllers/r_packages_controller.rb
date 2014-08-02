class RPackagesController < ApplicationController
  def show
    @r_package = RPackage.find(params[:id])
    @versions = @r_package.versions
  end
end
