require 'monitor'

module Rys
  class Feature
    extend MonitorMixin

    mattr_accessor :all_features
    self.all_features = {}

    mattr_accessor :plugins_stack
    self.plugins_stack = []

    attr_reader :key, :full_key, :parent, :children, :plugins
    attr_accessor :block_condition, :options

    def self.root
      Rys::RootFeature.instance
    end

    def self.for_plugin(plugin)
      plugins_stack.push(plugin)
      yield
    ensure
      plugins_stack.pop
    end

    def self.add(key, **options, &block_condition)
      synchronize {
        feature = root.fetch_or_create(key)
        feature.block_condition = block_condition
        feature.options = options
        feature.add_plugins(plugins_stack)
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

        # If one feature is inactive -> whole statement is inactive
        if !result
          return false
        end
      end

      true
    end

    # TODO: Measure time
    def self.on(*keys, &block)
      if active?(*keys)
        yield
      end
    end

    def initialize(key, parent)
      @key = key
      @parent = parent
      @block_condition = nil
      @options = {}
      @plugins = []

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
      # At the installation stage, we cannot check features, since there are no tables yet.
      return false if Redmine::Plugin.installation?

      if block_condition
        block_condition.call && parent.active?
      else
        RysFeatureRecord.active?(full_key) && parent.active?
      end
    end

    def add_plugins(plugins)
      plugins = Array(plugins)
      @plugins.concat(plugins)
      @plugins.uniq!

      if parent.root?
        # Root belongs to anyone
      else
        parent.add_plugins(plugins)
      end
    end

    def category
      options[:category]
    end

    def title
      translate_it :title, options[:title]
    end

    def description
      translate_it :description, options[:description]
    end

    def status_changed(active)
      options[:status_changed]&.(active)
    end

    def default_db_status
      options[:default_db_status].nil? ? true : options[:default_db_status]
    end

    private

      def translate_it(field, value)
        case value
        when Symbol
          ::I18n.translate(value)
        when String
          value
        else
          translation_full_key = full_key.gsub('.', '_')
          ::I18n.translate("rys_features.#{translation_full_key}.#{field}", default: full_key)
        end
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
