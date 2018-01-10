class RysFeaturesController < ApplicationController

  before_action :find_feature, only: [:update]

  def index
  end

  def update
    @feature.active = params[:active]
    @feature.save

    redirect_to rys_features_path
  end

  private

    def find_feature
      @feature = RysFeatureRecord.find_by(id: params[:id])
      return render_404 if @feature.nil?
    end

end
