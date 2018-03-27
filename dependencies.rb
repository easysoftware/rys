git_source(:easy_git){ |name| "git@git.easy.cz:platform-2.0/#{name}.git" }

group :rys do
  group :default do
    gem 'tty-prompt', require: false
  end
end
