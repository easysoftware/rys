module Rys
  module FeaturedRoutes
    module MapperV6

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

ActionDispatch::Routing::Mapper.prepend(Rys::FeaturedRoutes::MapperV6)
