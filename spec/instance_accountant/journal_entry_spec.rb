# -*- encoding : utf-8 -*-
require 'helpers'

require 'instance_accountant/journal_entry'

module InstanceAccountant
  Class JournalEntry do
    Instance do
      let(:options) do
        {
          subledger:    subledger,
          description:  description,
          cost:         cost,
          expense_acct: expense_acct,
          payable_acct: payable_acct
        }
      end

      let(:price_options) do
        {
          price:           price,
          income_acct:     income_acct,
          receivable_acct: receivable_acct
        }
      end

      let(:subledger)    { double 'subledger'         }
      let(:description)  { 'description with time %s' }

      let(:cost)         { double 'cost'         }
      let(:expense_acct) { double 'expense_acct' }
      let(:payable_acct) { double 'payable_acct' }

      let(:price)           { double 'price'           }
      let(:income_acct)     { double 'income_acct'     }
      let(:receivable_acct) { double 'receivable_acct' }

      let(:expense_debit)  { double 'expense_debit'  }
      let(:payable_credit) { double 'payable_credit' }

      let(:receivable_debit) { double 'receivable_debit' }
      let(:income_credit)    { double 'income_credit'    }

      let(:concat_desc) { 'description with time 2014-11-05T18:00:00Z' }

      let(:hour)        { double 'hour' }
      let(:hour_string) { '2014-11-05T18:00:00Z' }

      let(:now)  { double 'now'  }

      RespondsTo :hash_for do
        When 'price lines are not included' do
          subject { JournalEntry.new options }

          ByReturning true do
            expect(hour)
              .to receive(:hour_string)
              .and_return(hour_string)

            expect(subledger)
              .to receive(:account)
              .with(id: expense_acct)
              .and_return(expense_acct)

            expect(subledger)
              .to receive(:debit)
              .with(cost)
              .and_return(expense_debit)

            expect(subledger)
              .to receive(:account)
              .with(id: payable_acct)
              .and_return(payable_acct)

            expect(subledger)
              .to receive(:credit)
              .with(cost)
              .and_return(payable_credit)

            # expect(description)
            #   .to receive(:+)
            #   .and_return(concat_desc)

            subject.hash_for(hour, now)
              .must_equal effective_at: now,
                          description:  concat_desc,
                          lines: [
                            {
                              account: expense_acct,
                              value:   expense_debit
                            },
                            {
                              account: payable_acct,
                              value:   payable_credit
                            }
                          ]
          end
        end

        When 'price lines are included' do
          subject { JournalEntry.new options.merge price_options }

          ByReturning true do
            expect(hour)
              .to receive(:hour_string)
              .and_return(hour_string)

            expect(subledger)
              .to receive(:account)
              .with(id: expense_acct)
              .and_return(expense_acct)

            expect(subledger)
              .to receive(:debit)
              .with(cost)
              .and_return(expense_debit)

            expect(subledger)
              .to receive(:account)
              .with(id: payable_acct)
              .and_return(payable_acct)

            expect(subledger)
              .to receive(:credit)
              .with(cost)
              .and_return(payable_credit)

            expect(subledger)
              .to receive(:account)
              .with(id: receivable_acct)
              .and_return(receivable_acct)

            expect(subledger)
              .to receive(:debit)
              .with(price)
              .and_return(receivable_debit)

            expect(subledger)
              .to receive(:account)
              .with(id: income_acct)
              .and_return(income_acct)

            expect(subledger)
              .to receive(:credit)
              .with(price)
              .and_return(income_credit)

            # expect(description)
            #   .to receive(:+)
            #   .and_return(concat_desc)

            subject.hash_for(hour, now)
              .must_equal effective_at: now,
                          description:  concat_desc,
                          lines: [
                            {
                              account: expense_acct,
                              value:   expense_debit
                            },
                            {
                              account: payable_acct,
                              value:   payable_credit
                            },
                            {
                              account: receivable_acct,
                              value:   receivable_debit
                            },
                            {
                              account: income_acct,
                              value:   income_credit
                            }
                          ]
          end
        end
      end
    end
  end
end
