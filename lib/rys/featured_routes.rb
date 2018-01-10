module Rys
  module FeaturedRoutes
    module Mapper

      def add_route(action, options)
        easy_feature = options.delete(:easy_feature)

        if options[:constraints] && easy_feature
          raise ArgumentError, 'You cannot combine :constraints with :easy_feature.'
        end

        if easy_feature
          options[:constraints] = lambda {|_| Rys::Feature.active?(easy_feature) }
        end

        super
      end

      def easy_feature(feature)
        constraints = lambda {|_| Rys::Feature.active?(feature) }
        scope(constraints: constraints) { yield }
      end

    end
  end
end

ActionDispatch::Routing::Mapper.prepend(Rys::FeaturedRoutes::Mapper)
