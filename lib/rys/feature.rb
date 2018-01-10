require 'monitor'

module Rys
  class Feature
    extend MonitorMixin

    mattr_accessor :all_features
    self.all_features = {}

    attr_reader :key, :full_key, :parent, :children, :condition
    attr_accessor :condition

    def self.root
      Rys::RootFeature.instance
    end

    def self.add(key, &condition)
      synchronize {
        feature = root.fetch_or_create(key)
        feature.condition = condition
        feature
      }
    end

    def self.active?(*values)
      values.each do |value|
        result = case value
                 when Symbol, String
                   feature = all_features[value.to_s]
                   feature ? feature.active? : true
                 when Proc
                   value.call
                 else
                   true
                 end

        if !result
          return false
        end
      end

      true
    end

    def self.on(*keys, &block)
      if active?(*keys)
        yield
      end
    end

    def self.session_features
      if !RequestStore.store.has_key?(:rys_session_features)
        RequestStore.store[:rys_session_features] = {}
      end

      RequestStore.store[:rys_session_features]
    end

    def initialize(key, parent, &condition)
      @key = key
      @parent = parent
      @condition = condition

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
        new_feature = Rys::Feature.new(key, self)

        children[key] = new_feature
        all_features[new_feature.full_key] = new_feature
      end

      children[key].fetch_or_create(keys)
    end

    def active?
      (record && record.active?) && parent.active?
    end

    def record
      Rys::Feature.session_features[full_key] ||= RysFeatureRecord.find_by(name: full_key)
    end

  end
end

module Rys
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
