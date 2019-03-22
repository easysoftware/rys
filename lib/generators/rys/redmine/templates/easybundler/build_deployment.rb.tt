require_relative 'build'

module Easybundler
  class BuildDeployment < Build

    def target
      Rails.root.join('plugins/easysoftware/gems')
    end

    def build_from_rubygems(spec, path)
      if !Dir.exist?(spec.full_gem_path)
        print_gem_status(spec.name, 'not found')
        return false
      end

      # Copy files
      FileUtils.cp_r(spec.full_gem_path, path)

      # Delete all origin .gemspec files because
      # 1. User can include .gemspec directly (.gemspec will be there twice)
      # 2. Built .gemspec is always valid on any ruby
      FileUtils.rm Dir.glob(path.join('*.gemspec'))

      # Create .gemspec for bundler to load
      File.write(path.join(spec.spec_name), spec.to_ruby_for_cache)

      print_gem_status(spec.name, 'copied')
      true
    end

    def build_from_git(spec, path)
      if !Dir.exist?(spec.source.path)
        print_gem_status(spec.name, 'not found')
        return false
      end

      FileUtils.cp_r(spec.source.path, path)
      FileUtils.rm_rf(path.join('.git'))

      print_gem_status(spec.name, 'copied')
      true
    end

    def build_from_path(spec, path)
    end

  end
end
