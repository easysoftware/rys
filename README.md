# Rys

Name is a big mistery. Do not bother to figure it out :-).

Library is similar to Railties but within Redmine environment.

- plugin generator
- feature toggler
- patcher manager
- interface to Redmine

All you need to do is insert `gem 'rys'` into your Gemfile. If you want develop this gem or its plugis locally you can set bundler:

`bundle config local.GEM_NAME GEM_PATH`

#### Dependecies

Install all dependecies are not so easy like with redmine plugins. For this purpose check gem `rys-bundler`.

## Rys plugins

Target directory can be set via option `--path` or via environment varible `RYS_PLUGINS_PATH`. Otherwise `RAILS_ROOT/rys_plugins` is chosen.

```
rails generate rys:plugin --help
rails generate rys:plugin NAME
```

Also gem is automatically appended into `Gemfile.local`.

## Features

You can toggle some code base on database state or by custom definiton. First you need to register features.

```ruby
# Basic definition
# This feature will be active if record on the DB will have active == true
Rys::Feature.add('issue.show')
```

All features have tree structure so if parent is disabled all children are disabled too. For example:

```ruby
Rys::Feature.add('issue.show')
Rys::Feature.add('issue.show.sidebar')

# issue
# `-- issue.show
#     `-- issue.show.sidebar
```

If `issue` is disabled -> all `issue.*` are disabled too regardless to theirs state.

You can check feature state via:

```ruby
Rys::Feature.on('issue.show') do
  # issue.show is active
end

if Rys::Feature.active?('issue.show')
  # issue.show is active
end
```

### In routes

```ruby
get 'path', rys_feature: 'issue.show'

rys_feature 'issue.show' do
  get 'path'
end
```

### In patches

More details can be found at Patch manager section.

```ruby
instance_methods(feature: 'issue.show') do
  def show
    # Something todo
    # if feature is active
    super
  end
end
```


### Custom condition

If you don't want to use DB record checking you can define custom condition.

```ruby
# Ruby block state
Rys::Feature.add('issue.show') do
  rand(0..10) == 1
end
```

Or you can use both approaches with:

```ruby
Rys::Feature.add('issue.show') do
  rand(0..10) == 1 && RysFeatureRecord.active?('issue.show')
end
```

# Patch manager

You can easily define patches for your Rails projects in just two steps.

First you need to register path to directory

```ruby
# extend your engine
include ::Rys::EngineExtensions

# or manually
Rys::Patcher.paths << PATH_TO_DIRECTORY
```

Now you can define a patch

```ruby
Rys::Patcher.add(CLASS_TO_PATCH) do

  apply_only_once!

  apply_if do
    CONDITION
  end

  included do
    # This section is evaluated in CLASS_TO_PATCH
  end

  instance_methods do
    # Your instance methods
  end

  instance_methods(feature: FEATURE) do
    # Your conditional methods
  end

  class_methods do
    # Your class methods
  end

end

```

So your patch can look like this

```ruby
Rys::Patcher.add('IssuesController') do

  included do
    before_action :add_flash_notice, only: [:show]
  end

  instance_methods do

    def show
      flash.now[:notice] = 'Hello'
      super
    end

  end
end
```

#### Generating

Patches can be generated via command:

```
rails generate rys:patch TYPE PLUGIN NAME

rails generate rys:patch m RYS_PLUGIN_NAME Issue
rails generate rys:patch model RYS_PLUGIN_NAME Issue
rails generate rys:patch helper RYS_PLUGIN_NAME Issues
```

Or you can use interactive generator

```
rails generate rys:ipatch
```

### Rails generators

You can use the same generator like in any Rails plugin. Just add prefix `rys` and specify Rys plugin name.

```
rails generate rys:model RYS_PLUGIN_NAME ...normal arguments...
rails generate rys:scaffold RYS_PLUGIN_NAME ...normal arguments...
rails generate rys:controller RYS_PLUGIN_NAME ...normal arguments...
```
