# -*- encoding : utf-8 -*-
require 'time'

module InstanceAccountant
  class Hour
    def initialize options = { }
      @time = options[:time] ? options[:time].utc : now(options)
    end

    def == other
      hour_string == other.hour_string
    end

    def to_s
      @time.iso8601
    end

    def hour_string
      to_s[0..12] + ':00:00Z'
    end

    private

    def now options
      (options[:time_klass] || ::Time).now.utc
    end
  end
end
