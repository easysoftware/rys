module Rys
  class Patcher

    mattr_accessor :paths
    self.paths = []

    mattr_accessor :patches
    self.patches = []

    mattr_accessor :applied_count
    self.applied_count = 0

    def self.add(klass_to_patch, &block)
      patches << Patch.new(klass_to_patch, &block)
      self
    end

    def self.reload_patches
      patches.clear
      paths.each do |path|
        pattern = File.join(path, '**/*.rb')
        Dir.glob(pattern){|f| load(f) }
      end
    end

    def self.apply(where: nil)
      patches.each do |patch|
        next if patch.where != where

        begin
          klass_to_patch = patch.klass.constantize
        rescue
          # Pokud neni namigrovana setting tabulka aplikace preskoci nacteni easy pluginu.
          # Kvuli cemuz nasledne nezna patchovane konstanty.
          # Zpusobuje tento modul EasyProjectLoader.init!
          if const_defined?(:Rake) && Rake.application.top_level_tasks.include?("db:migrate")
            next
          else
            raise
          end
        end

        if patch.apply_only_once && applied_count != 0
          next
        end

        if patch.apply_if && !patch.apply_if.call
          next
        end

        patch.includeds.each do |included|
          klass_to_patch.class_eval(&included)
        end

        patch.instance_methods.each do |options, block|
          prepended_methods(klass_to_patch, options, block)
        end

        patch.class_methods.each do |options, block|
          prepended_methods(klass_to_patch.singleton_class, options, block)
        end
      end
    end

    # TODO: What should happen if
    #   instance_methods(feature: ...) do
    #     def uniq_method_which_does_not_exist_yet
    #     end
    #   end
    #
    def self.prepended_methods(klass_to_patch, options, block)
      mod = Rys::PatchModule.new(&block)

      if options[:feature]
        # Save original methods
        method_list = mod.instance_methods.map{|m| [m, "#{m}_#{SecureRandom.hex}"] }
        method_list.each do |m, aliased_m|
          klass_to_patch.send(:alias_method, aliased_m, m)
        end
      end

      klass_to_patch.prepend(mod)

      if options[:feature]
        mod = Rys::PatchModule.new do
          method_list.each do |m, aliased_m|
            define_method(m) do |*args, &block|
              if ::Rys::Feature.active?(options[:feature])
                super(*args, &block)
              else
                # method(__method__).super_method.super_method.call(*args, &block)
                __send__(aliased_m, *args, &block)
              end
            end
          end
        end

        klass_to_patch.prepend(mod)
      end
    end

  end
end

module Rys
  class PatcherDSL

    def initialize
      @_where = nil
      @_apply_if = nil
      @_apply_only_once = false
      @_includeds = []
      @_instance_methods = []
      @_class_methods = []
    end

    def _result
      {
        where: @_where,
        apply_if: @_apply_if,
        apply_only_once: @_apply_only_once,
        includeds: @_includeds,
        instance_methods: @_instance_methods,
        class_methods: @_class_methods,
      }
    end

    def name
      # Comming soon
    end

    def before
      # Comming soon
    end

    def where(place)
      @_where = place
    end

    def apply_if(value=nil, &block)
      if block_given?
        @_apply_if = block
      elsif value.is_a?(Proc)
        @_apply_if = value
      else
        raise '`apply_if` require Proc or block'
      end
    end

    def apply_only_once!
      @_apply_only_once = true
    end

    def included(&block)
      @_includeds << block
    end

    def instance_methods(**options, &block)
      @_instance_methods << [options, block]
    end

    def class_methods(**options, &block)
      @_class_methods << [options, block]
    end

    alias_method :includeds, :included
  end
end

module Rys
  class PatchModule < Module

    def remove_patch_methods
      instance_methods.each do |met|
        remove_method met
      end
    end

  end
end

module Rys
  class Patch

    attr_reader :klass, :result

    def initialize(klass, &block)
      @klass = klass

      dsl = Rys::PatcherDSL.new
      dsl.instance_eval(&block)
      @result = dsl._result
    end

    def where
      result[:where]
    end

    def apply_only_once
      result[:apply_only_once]
    end

    def apply_if
      result[:apply_if]
    end

    def includeds
      result[:includeds]
    end

    def instance_methods
      result[:instance_methods]
    end

    def class_methods
      result[:class_methods]
    end

  end
end
