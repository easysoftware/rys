module Rys
  module FeaturedRoutes
    module MapperV4

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

module Rys
  module FeaturedRoutes
    module MapperV5

      def add_route(action, controller, options, _path, to, via, formatted, anchor, options_constraints)
        rys_feature = options.delete(:rys_feature)

        if options_constraints.present? && rys_feature
          raise ArgumentError, 'You cannot combine :constraints with :rys_feature.'
        end

        if rys_feature
          options_constraints = lambda {|_| Rys::Feature.active?(rys_feature) }
        end

        super(action, controller, options, _path, to, via, formatted, anchor, options_constraints)
      end

      def rys_feature(feature)
        constraints = lambda {|_| Rys::Feature.active?(feature) }
        scope(constraints: constraints) { yield }
      end

    end
  end
end

if Rys.utils.rails4?
  ActionDispatch::Routing::Mapper.prepend(Rys::FeaturedRoutes::MapperV4)
elsif Rys.utils.rails5?
  ActionDispatch::Routing::Mapper.prepend(Rys::FeaturedRoutes::MapperV5)
end
