module Rys
  module FeaturedRoutes
    module Mapper

      def add_route(action, options)
        rys_feature = options.delete(:rys_feature)

        if options[:constraints] && rys_feature
          raise ArgumentError, 'You cannot combine :constraints with :rys_feature.'
        end

        if rys_feature
          options[:constraints] = lambda {|_| Rys::Feature.active?(rys_feature) }
        end

        super
      end

      def rys_feature(feature)
        constraints = lambda {|_| Rys::Feature.active?(feature) }
        scope(constraints: constraints) { yield }
      end

    end
  end
end

ActionDispatch::Routing::Mapper.prepend(Rys::FeaturedRoutes::Mapper)
