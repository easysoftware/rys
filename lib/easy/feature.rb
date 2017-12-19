require 'monitor'

module Easy
  class Feature
    extend MonitorMixin

    mattr_accessor :all_features
    self.all_features = {}

    attr_reader :key, :full_key, :parent, :children, :condition
    attr_accessor :condition

    def self.root
      Easy::RootFeature.instance
    end

    def self.add(key, &condition)
      synchronize {
        feature = root.fetch_or_create(key)
        feature.condition = condition
        feature
      }
    end

    def self.active?(value)
      case value
      when Symbol, String
        feature = all_features[value.to_s]
        feature ? feature.active? : true
      when Proc
        value.call
      else
        true
      end
    end

    def self.on(key, &block)
      if active?(key)
        yield
      end
    end

    def self.migrate_new
      return unless Easy::FeatureRecord.table_exists?

      binding.pry unless $__binding
    end

    def initialize(key, parent, &condition)
      @key = key
      @parent = parent
      @condition = condition || lambda { true }

      @full_key = parent.root? ? key : "#{parent.full_key}.#{key}"
      @children = {}
    end

    def root?
      false
    end

    def fetch_or_create(key)
      if key.blank?
        return self
      end

      if key.is_a?(Array)
        keys = key
      else
        keys = key.to_s.split('.')
      end

      keys = keys.dup
      key = keys.shift.to_s

      if !children.has_key?(key)
        new_feature = Easy::Feature.new(key, self)

        children[key] = new_feature
        all_features[new_feature.full_key] = new_feature
      end

      children[key].fetch_or_create(keys)
    end

    def active?
      condition.call && parent.active?
    end

  end
end

module Easy
  class RootFeature < Feature
    include Singleton

    def initialize
      @children = {}
    end

    def root?
      true
    end

    def active?
      true
    end

  end
end
