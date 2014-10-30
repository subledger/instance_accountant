# -*- encoding : utf-8 -*-
require 'subledger'

require 'time'

require 'instance_accountant/filer'
require 'instance_accountant/hour'
require 'instance_accountant/journal_entry'

module InstanceAccountant
  class Poster
    def initialize options = { }
      @options = options

      @time_klass = @options[:time_klass] || Time
      @hour_klass = @options[:hour_klass] || Hour

      @subledger     = @options[:subledger]     || Subledger.new(@options.dup)
      @filer         = @options[:filer]         || Filer.new(@options)
      @journal_entry = @options[:journal_entry] || JournalEntry.new(@options)
    end

    def post hour, now
      if posted? hour
        false
      else
        write hour, now
        true
      end
    end

    private

    def posted? hour
      file_time = @filer.read

      if file_time.nil?
        false
      else
        @hour_klass.new( time: file_time ) == hour
      end
    end

    def write hour, now
      @subledger
        .journal_entry
        .create_and_post( @journal_entry.hash_for hour, now )

      @filer.write hour
    end
  end
end
