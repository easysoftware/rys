require 'thread'

module Rys
  ##
  # Rys::FeaturePreload
  #
  # Save features used in specific action (e.g. '/issues')
  # to preload them at once on the same action in the future.
  #
  class FeaturePreload

    def initialize(app)
      @app = app
      @mutex = Mutex.new
      @features_for_paths = {}
    end

    def call(env)
      load_features(env)
      response = @app.call(env)
      save_features(env)

      response
    end

    private

      def load_features(env)
        path = env['PATH_INFO'].to_s
        features = Array(@features_for_paths[path])

        features = RysFeatureRecord.where(name: features)
        features.each do |feature|
          Rys::Feature.session_features[feature.name] = feature
        end
      end

      def save_features(env)
        features = Rys::Feature.session_features.keys
        path = env['PATH_INFO'].to_s

        @mutex.synchronize {
          features.concat Array(@features_for_paths[path])
          features.uniq!

          @features_for_paths[path] = features
        }
      end

  end
end
