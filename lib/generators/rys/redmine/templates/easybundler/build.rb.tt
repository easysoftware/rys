require 'bundler'
require 'yaml'

require_relative 'easybundler'

module Easybundler
  class Build

    COMMENT_PREFIX = '# EASYBUNDLER #'
    REST_NAMES = {} #{"ryspec" => "plugins/easysoftware/Gemfile"}

    def self.run!(**options)
      instance = new(**options)

      if options[:revert]
        instance.run_revert
      else
        instance.run
      end
    end

    def initialize(**options)
      @options = options

      # Bundler::SpecSet<Bundler::StubSpecification>
      @all_specs = Bundler.definition.specs

      @copied = []
      @longest_name_size = @all_specs.map{ |s| s.name.size }.max
    end

    def run
      FileUtils.mkdir_p(target)

      copy_dependencies
      comment_copied
      comment_rest
      # change_sources
      save_report
    end

    def run_revert
      delete_dependencies
      uncomment_deleted
      delete_report

      FileUtils.rm_rf(target)
      FileUtils.mkdir_p(target)
      FileUtils.touch(target.join('.keep'))
    end

    private

      def easygems_spec?(spec)
        host = spec.metadata['allowed_push_host']
        host && host =~ Easybundler::EASYGEMS_HOST_MATCH
      end

      def easygit_spec?(spec)
        host = spec.source.uri
        host && host =~ Easybundler::EASYGIT_HOST_MATCH
      end

      def print_gem_status(name, status)
        puts (name + ' ').ljust(@longest_name_size, '.') + " #{status}"
      end

      def copy_dependencies
        @all_specs.each do |spec|
          path = target.join(spec.name)

          if path.directory?
            print_gem_status(spec.name, 'already copied')
            next
          end

          case spec.source
          when Bundler::Source::Rubygems
            if easygems_spec?(spec) && build_from_rubygems(spec, path)
              @copied << spec.name
            end

          # Git inherit from the Path so in case must be before Path
          when Bundler::Source::Git
            if easygit_spec?(spec) && build_from_git(spec, path)
              @copied << spec.name
            end

          when Bundler::Source::Path
            # build_from_path(spec, path)
          end
        end
      end

      def delete_dependencies
        build_report.each do |name, options|
          path = target.join(name)

          if File.symlink?(path)
            FileUtils.rm(path)
            print_gem_status(name, 'symlink removed')
          elsif File.directory?(path)
            FileUtils.rm_rf(path)
            print_gem_status(name, 'directory removed')
          else
            print_gem_status(name, 'nor symlink or directory')
          end
        end
      end

      def comment_copied
        if @copied.size == 0
          return
        end

        puts
        puts 'Commenting gems'
        Bundler.definition.gemfiles.each do |gemfile|
          gem_names = comment_gems_in(gemfile, @copied)

          if gem_names.size > 0
            gemfile_relative = gemfile.relative_path_from(Bundler.root)
            gem_names.each do |gem_name|
              build_report[gem_name] = { 'origin' => gemfile_relative.to_s }
            end
          end

          puts "* #{short_pathname(gemfile)}: #{gem_names.size} occurrences"
        end
      end

      # def change_sources
      #   puts
      #   puts 'Changing sources'
      #   Bundler.definition.gemfiles.each do |gemfile|
      #     commented = change_sources_in(gemfile)
      #   end
      # end

      def uncomment_deleted
        if build_report.size == 0
          return
        end

        puts
        puts 'Uncommenting gems'

        all_origins = Hash.new { |hash, origin| hash[origin] = [] }

        build_report.each do |gem_name, options|
          all_origins[options['origin']] << gem_name
        end
        REST_NAMES.each do |gem_name, path|
          all_origins[path] << gem_name
        end
        all_origins["plugins/easysoftware/Gemfile"] << "ryspec"

        all_origins.each do |origin, gem_names|
          origin_gemfile = Bundler.root.join(origin)

          if origin_gemfile.exist?
            gem_names = uncomment_gems_in(origin_gemfile, gem_names)
            puts "* #{short_pathname(origin_gemfile)}: #{gem_names.size} occurrences"
          else
            puts "* #{short_pathname(origin_gemfile)}: not exist"
          end
        end
      end

      def comment_rest
        @comment_gems_pattern = nil
        Bundler.definition.gemfiles.each do |gemfile|
          comment_gems_in(gemfile, REST_NAMES.keys)
        end
      end

      def comment_gems_in(path, gem_names)
        # Pattern can exist across calling
        @comment_gems_pattern ||= /^(\s*)([^#|\n]*gem[ ]+["'](#{gem_names.join('|')})["'])/

        names = []
        content = File.binread(path)
        content.gsub!(@comment_gems_pattern) do
          names << $3
          %{#{$1}#{COMMENT_PREFIX} #{$2}}
        end

        File.open(path, 'wb') { |file| file.write(content) }
        names.uniq!
        names
      end

      def uncomment_gems_in(path, gem_names)
        pattern = /^(\s*)#{COMMENT_PREFIX}[ ]*(gem[ ]+["'](#{gem_names.join('|')})["'])/

        names = []
        content = File.binread(path)
        content.gsub!(pattern) do
          names << $3
          %{#{$1}#{$2}}
        end

        File.open(path, 'wb') { |file| file.write(content) }
        names.uniq!
        names
      end

      # def change_sources_in(path)
      #   # Pattern can exist across calling
      #   @change_sources_pattern ||= /^(\s*)source[\ \(\"\'\']*#{Easybundler::EASYGEMS_HOST_MATCH}.*/

      #   count = 0
      #   content = File.binread(path)
      #   content.gsub!(@change_sources_pattern) do
      #     count += 1
      #     %{#{$1}source 'https://rubygems.org' do}
      #   end

      #   File.open(path, 'wb') { |file| file.write(content) }
      #   count
      # end

      def short_pathname(path)
        path.each_filename.to_a.last(2).join('/')
      end

      def build_yml
        target.join('build.yml')
      end

      def build_report
        @build_report ||= begin
          if build_yml.exist?
            YAML.load_file(build_yml)
          else
            {}
          end
        end
      end

      def save_report
        report  = %{# This file was generated by Easybundler at #{Time.now}\n}
        report << %{# Modify file at your own risk\n}
        report << build_report.to_yaml

        build_yml.write(report)
      end

      def delete_report
        build_yml.exist? && build_yml.delete
      end

  end
end
