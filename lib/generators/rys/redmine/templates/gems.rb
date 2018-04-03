git_source(:easy_git){ |name| "git@git.easy.cz:platform-2.0/#{name}.git" }

group :default, :rys do
  # gem 'rys', easy_git: 'rys', branch: 'master'
end

this_dir = Pathname.new(__dir__)

all_gemspecs = Pathname.glob(this_dir.join('{gems,local}/*/*.gemspec'))
all_gemspecs.each do |gemspec|
  gem gemspec.basename.sub('.gemspec', '').to_s, path: gemspec.dirname
end

plugin 'rys-bundler', easy_git: 'rys-bundler', branch: 'master'
Plugin.hook('rys-gemfile', self)
