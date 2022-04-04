require 'rails/generators'
require 'rails/generators/rails/plugin/plugin_generator'

module Rys
  class PluginBuilder < ::Rails::PluginBuilder

    def app
      if mountable?
        if api?
          directory "app", exclude_pattern: %r{app/(views|helpers)}
        else
          directory "app"
        end

        remove_dir "app/mailers" if options[:skip_action_mailer]
        remove_dir "app/jobs" if options[:skip_active_job]
      elsif full?
        empty_directory_with_keep_file "app/models"
        empty_directory_with_keep_file "app/controllers"
        empty_directory_with_keep_file "app/mailers" unless options[:skip_action_mailer]
        empty_directory_with_keep_file "app/jobs" unless options[:skip_active_job]

        unless api?
          empty_directory_with_keep_file "app/helpers"
          empty_directory_with_keep_file "app/views"
        end
      end
    end

    def rubocop
      template '.rubocop.yml'
    end

    def changelog
      template 'CHANGELOG.md'
    end

    def readme
      template 'README.md'
    end

    def gemfile
      template 'gems.rb'
    end

    def config
      super
      template 'config/locales/en.yml'
      directory 'config/initializers'
    end

    def lib
      template "lib/%namespaced_name%.rb"
      template "lib/tasks/%namespaced_name%_tasks.rake"
      template "lib/%namespaced_name%/version.rb"
      template "lib/%namespaced_name%/engine.rb"
    end

    def gitignore
      template '.gitignore'
    end

    def gemfile_entry
    end

    def test_dummy_assets
      # ignore assets
    end

  end

  class PluginGenerator < ::Rails::Generators::PluginGenerator
    source_root File.expand_path('templates', __dir__)

    class_option :path, type: :string

    class_option :rys_author, type: :string,
                 desc: 'The author of the Rys'

    self.source_paths << source_root
    self.source_paths << Rails::Generators::PluginGenerator.source_root

    def self.exit_on_failure?
      true
    end

    def initialize(*args)
      super

      if options[:path].present?
        path = options[:path]
        @destination_root_by = :path
      elsif ENV.has_key?('RYS_PLUGINS_PATH')
        path = ENV['RYS_PLUGINS_PATH']
        @destination_root_by = :env
      else
        path = Rails.root.join('rys_plugins').to_s
        FileUtils.mkdir_p(path)
        @destination_root_by = :in_root
      end

      if !Dir.exist?(path)
        raise NameError, "Path '#{path}' does not exist."
      end

      self.destination_root = path
    end

    def mountable?
      false
    end

    def full?
      true
    end

    def with_dummy_app?
      false
    end

    def name_pluralize
      @name_pluralize ||= name.pluralize
    end

    def underscored_name_pluralize
      @underscored_name_pluralize ||= underscored_name.pluralize
    end

    def get_builder_class
      PluginBuilder
    end

    def create_root_files
      build(:readme)
      build(:rakefile)
      build(:gemspec)
      build(:gitignore) unless options[:skip_git]
      build(:gemfile)
      build(:rubocop)
      build(:changelog)
      directory 'api'
      directory 'db'
      template '.gitlab-ci.yml'
      template '.rspec'
    end

    def create_patches
      directory 'patches'
    end

    def create_test_files
      directory 'spec'
      directory 'test'
    end

    def create_view_example
      template 'app/views/issues/%namespaced_name%/_view_issues_show_details_bottom.html.erb'
    end

    def append_to_gemfile
      return if options[:skip_git]

      gemfile_local = Rails.root.join('Gemfile.local')

      create_file gemfile_local unless gemfile_local.exist?

      case @destination_root_by
      when :path
        path = "'#{destination_root}'"
      when :env
        path = "ENV['RYS_PLUGINS_PATH'] + '/#{app_path}'"
      when :in_root
        path = "'rys_plugins/#{app_path}'"
      end

      entry = <<-STR.strip_heredoc
        if Dir.exists?(#{path})
          gem '#{name}', path: #{path}, group: [:default, :rys]
        end
      STR

      append_file gemfile_local, entry
    end

    def after_generated
      Rys::Hook.('rys.plugin_generator.after_generated', self)
    end

    def init_git
      return if options[:skip_git]

      # Capture for less verbose
      run 'git init', capture: true
      git add: '.'
    end

    def informations
      shell.say_status 'INFO', ''
      shell.say_status 'INFO', ''
      shell.say_status 'INFO', "Plugin was created in: #{destination_root}"
      shell.say_status 'INFO', "To set local path: bundle config local.#{name} #{destination_root}"

      one_liners = Rys::Engine.root.join('config/one_liners.txt')
      if one_liners.exist?
        line = one_liners.readlines.sample
        shell.say_status 'INFO', ''
        shell.say_status 'INFO', %{"#{line.chomp}"}
      end
    end

    def dotted_name
      @dotted_name ||= name.tr('-', '.')
    end

    private

    def author
      options['rys_author'].presence || super
    end

    def modules_wrap(unwrapped_code, commented: false)
      prefix = commented ? '# ' : ''

      modules.reverse.inject(unwrapped_code.strip_heredoc.strip) do |content, mod|
        str = "#{prefix}module #{mod}\n"
        str += content.lines.map { |line| "#{prefix}  #{line}" }.join
        str += content.present? ? "\n#{prefix}end" : "#{prefix}end"
      end
    end

    def commented_modules_wrap(unwrapped_code)
      modules_wrap(unwrapped_code, commented: true)
    end

  end
end
