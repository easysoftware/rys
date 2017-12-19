class EasyFeaturesController < EasyApplicationController

  before_action :find_feature, only: [:update]

  def index
  end

  def update
    @feature.active = params[:active]
    @feature.save

    redirect_to easy_features_path
  end

  private

    def find_feature
      @feature = EasyFeatureRecord.find_by(id: params[:id])
      return render_404 if @feature.nil?
    end

end
