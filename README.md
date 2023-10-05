# Rys 

Rys is a new plugin system/platform for Redmine, Easy Redmine and Easy Project. 
With Rys, you can easily create and manage plugins for your Redmine-based project management system

Go to the [rys wiki](https://github.com/easysoftware/rys/wiki) to see more details.

## Installation
Add this line to your application's Gemfile:

```Gemfile
gem "rys" --source "https://gems.easysoftware.com"
```
then execute:
```bash
bundle install
```
Or simply:
```bash
bundle add rys --source "https://gems.easysoftware.com"
```

## Configuration
To configure Rys, you need to create a file named `31-rysy.rb` in the `config/initializers` directory of your Easy Redmine application.
In this file, you can apply patches and configure Rys as follows:
```ruby
# config/initializers/31-rysy.rb
Rys.apply_patches!
```