# Rys

Name is a big mistery. Do not bother to figure it out :-).

Library contains feature togglers, patcher manager and engine generator.

All you need to do is insert `gem 'rys'` into your Gemfile.

## Features

You can toggle some code base on database state.

```ruby
# Basic definition
# This feature will be active if record on the DB will have active == true
Rys::Feature.add('issue.show')
```

All features have tree structure so if parent disabled all children are disabled too. For example

```ruby
Rys::Feature.add('issue.show')
Rys::Feature.add('issue.show.sidebar')

# issue
# `-- issue.show
#     `-- issue.show.sidebar
```

If `issue` is disabled -> all `issue.*` are disabled too regardless to theirs state.

You can check feature in many ways.

```ruby
Rys::Feature.on('issue.show') do
  # issue.show is active
end

if Rys::Feature.active?('issue.show')
  # issue.show is active
end
```

In routes definition

```ruby
get 'path', rys_feature: 'issue.show'

rys_feature 'issue.show' do
  get 'path'
end
```

In patches (more details in Patch manager section)

```ruby
# ...

instance_methods(feature: 'issue.show') do
  def show
  # Something todo
    # if feature is active
    super
  end
end

# ...
```


#### Idea for future


```ruby
# Ruby block state
Rys::Feature.add('issue.show') do
  rand(0..10) == 1
end
```

# Patch manager

You can easily define patches for your Rails projects in just two steps.

First you need to register path to directory

```ruby
# extend your engine
extend ::Rys::PluginEngine

# or manually
Rys::Patcher.paths << PATH_TO_DIRECTORY
```

Now you can define patch

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

## Engine generator

```
rails g rys:engine NAME
```

That will generate plugin into `rys_plugins` and add record into your `Gemfile.local`.
