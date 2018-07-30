module Rys
  class Reloader

    def self.to_prepare(&block)
      reloader_klass = defined?(ActiveSupport::Reloader) ? ActiveSupport::Reloader : ActionDispatch::Reloader
      reloader_klass.to_prepare(&block)
    end

  end
end
