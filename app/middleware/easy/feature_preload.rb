module Easy
  ##
  # Easy::FeaturePreload
  #
  # Save features used in specific action (e.g. '/issues')
  # to preload them at once on the same action in the future.
  #
  class FeaturePreload

    def initialize(app)
      @app = app
    end

    def call(env)
      @app.call(env)
    end

  end
end
