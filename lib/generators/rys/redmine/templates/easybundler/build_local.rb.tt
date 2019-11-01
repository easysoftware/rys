require_relative 'build'

module Easybundler
  class BuildLocal < Build

    def target
      Rails.root.join('plugins/easysoftware/local')
    end

    def build_from_rubygems(spec, path)
      local_path = Bundler.settings["local.#{spec.name}"]

      if local_path && Dir.exist?(local_path)
        source_path = local_path
      elsif Dir.exist?(spec.full_gem_path)
        source_path = spec.full_gem_path
      else
        print_gem_status(spec.name, 'not found')
        return false
      end

      path.make_symlink(source_path)
      print_gem_status(spec.name, "linked from #{source_path}")
      true
    end

    def build_from_git(spec, path)
      if !Dir.exist?(spec.source.path)
        print_gem_status(spec.name, 'not found')
        return false
      end

      path.make_symlink(spec.source.path)
      print_gem_status(spec.name, "linked from #{spec.source.path}")
      true
    end

    def build_from_path(spec, path)
    end

  end
end
