# -*- encoding : utf-8 -*-
require 'subledger'

module InstanceAccountant
  class JournalEntry
    def initialize options = { }
      @options = options

      @subledger = options[:subledger] || Subledger.new(@options.dup)
    end

    def hash_for hour, now
      hour_string = hour.hour_string

      lines = cost_lines hour_string

      lines += price_lines(hour_string) if include_price_lines?

      hash = {
        effective_at: now,
        description:  description(hour_string),
        lines:        lines
      }

      hash.merge!(reference: @options[:reference]) if @options[:reference]

      hash
    end

    private

    def include_price_lines?
      @options[:receivable_acct]     and
        @options[:income_acct]       and
        @options[:price]
    end

    def description hour_string
      format @options[:description], hour_string
    end

    def cost_lines hour_string
      lines = [ ]

      common = { description: @options[:cost_description],
                 reference:   @options[:cost_reference] }

      lines << complete(
                 hour_string,
                 common.merge( account: expense_acct,
                               value:   @subledger.debit(@options[:cost]) ) )

      lines << complete(
                 hour_string,
                 common.merge( account: payable_acct,
                               value:   @subledger.credit(@options[:cost]) ) )

      lines
    end

    def price_lines hour_string
      lines = [ ]

      common = { description: @options[:price_description],
                 reference:   @options[:price_reference] }

      lines << complete(
                 hour_string,
                 common.merge( account: receivable_acct,
                               value:   @subledger.debit(@options[:price]) ) )

      lines << complete(
                 hour_string,
                 common.merge( account: income_acct,
                               value:   @subledger.credit(@options[:price]) ) )

      lines
    end

    def complete hour_string, args
      description = args[:description].nil? ? nil : description(hour_string)

      if description
        args.merge! description: description
      else
        args.delete :description
      end

      reference = args[:reference]

      if reference
        args.merge! reference: reference
      else
        args.delete :reference
      end

      args
    end

    def expense_acct
      @subledger.account id: @options[:expense_acct]
    end

    def payable_acct
      @subledger.account id: @options[:payable_acct]
    end

    def receivable_acct
      @subledger.account id: @options[:receivable_acct]
    end

    def income_acct
      @subledger.account id: @options[:income_acct]
    end
  end
end
