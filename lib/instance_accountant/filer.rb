# -*- encoding : utf-8 -*-

module InstanceAccountant
  class Filer
    def initialize options = { }
      @file_klass = options[:file_klass] || File
      @time_klass = options[:time_klass] || Time

      @filepath = @file_klass.expand_path options[:filepath]
    end

    def read
      hour_string = nil

      @file_klass.open( @filepath, 'r' ) do |file|
        file.flock File::LOCK_EX
        hour_string = file.read
      end

      @time_klass.parse hour_string
    rescue
      nil
    end

    def write hour
      hour_string = hour.hour_string

      @file_klass.open( @filepath,
                        File::RDWR | File::CREAT,
                        0644 ) do |file|
        file.flock File::LOCK_EX
        file.truncate 0
        file.write hour_string
      end

      hour_string
    end
  end
end
