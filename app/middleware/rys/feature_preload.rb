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
        return if path.start_with?('/assets')

        features = Array(@features_for_paths[path])
        return if features.empty?

        features = ::RysFeatureRecord.where(name: features)
        features.each do |feature|
          ::RysFeatureRecord.request_store[feature.name] = feature
        end
      end

      def save_features(env)
        features = ::RysFeatureRecord.request_store.keys
        path = env['PATH_INFO'].to_s

        @mutex.synchronize {
          features.concat Array(@features_for_paths[path])
          features.uniq!

          @features_for_paths[path] = features
        }
      end

  end
end
