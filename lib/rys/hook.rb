module Rys
  class Hook

    @@registered = Hash.new { |hash, name| hash[name] = [] }

    def self.register(name, &block)
      @@registered[name.to_s] = block
      self
    end

    def self.call(name, *args)
      @@registered[name.to_s].call(*args)
    end

  end
end

