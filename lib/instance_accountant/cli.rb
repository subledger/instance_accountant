# -*- encoding : utf-8 -*-
require 'thor'

require 'instance_accountant'

module InstanceAccountant
  class CLI < Thor
    desc 'account', 'Accounts for hours in Subledger'

    method_option :filepath,
                  aliases: :f,
                  default: '~/.instance_accountant'

    method_option :description,
                  aliases:  :d,
                  required: true,
                  default:  'instance usage for: %'

    method_option :reference

    method_option :cost,
                  aliases:  :c,
                  required: true
    method_option :cost_description,
                  default: 'instance cost for: %'

    method_option :cost_reference

    method_option :expense_acct,
                  aliases:  :e,
                  required: true

    method_option :payable_acct,
                  aliases:  :p,
                  required: true

    method_option :price,
                  aliases: :p

    method_option :price_description,
                  default: 'instnace price for: %'

    method_option :price_reference

    method_option :income_acct,
                  aliases: :i

    method_option :receivable_acct,
                  aliases: :r

    method_option :key_id,
                  aliases:  :k,
                  required: true

    method_option :secret,
                  aliases:  :s,
                  required: true

    method_option :org_id,
                  aliases:  :o,
                  required: true

    method_option :book_id,
                  aliases:  :b,
                  required: true

    method_option :daemon, type: :boolean

    SIGNALS = []

    SECONDS_BETWEEN_ATTEMPTS = 10

    %w(ABRT ALRM HUP INT STOP TERM QUIT).each do |signal|
      Signal.trap signal do
        SIGNALS << signal
      end
    end

    def account
      if price_but_not_income_and_receivable options
        STDERR.puts '--price requires --income_acct and --receivable_acct'
        exit 0
      end

      i = 0

      loop do
        consider_posting i, options
        consider_exiting
        sleep 1
        i += 1
      end
    end

    private

    def consider_posting i, options
      Poster.new(options).post(Hour.new, Time.now) if posting_required? i
    rescue Exception => e
      STDERR.puts e
    end

    def posting_required? i
      (i % SECONDS_BETWEEN_ATTEMPTS).zero? or signal?
    end

    def consider_exiting
      exit 1 if signal?
      exit 0 if not_daemon?
    end

    def signal?
      SIGNALS.length > 0
    end

    def not_daemon?
      options[:daemon].nil?
    end

    def price_but_not_income_and_receivable options
      options[:price] and
        ! (options[:income_acct] and options[:receivable_acct])
    end
  end
end
