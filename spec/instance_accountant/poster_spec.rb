# -*- encoding : utf-8 -*-
require 'helpers'

require 'instance_accountant/poster'

module InstanceAccountant
  Class Poster do
    Instance do
      subject { Poster.new options }

      let(:options) do
        {
          subledger:         subledger,
          filer:             filer,
          hour_klass:        hour_klass,
          journal_entry:     journal_entry
        }
      end

      let(:subledger)          { double 'subledger'          }
      let(:sl_journal_entry)   { double 'sl_journal_entry'   }

      let(:filer)              { double 'filer'              }
      let(:hour_klass)         { double 'hour_klass'         }
      let(:journal_entry)      { double 'journal_entry'      }

      let(:journal_entry_hash) { double 'journal_entry_hash' }
      let(:hour)               { double 'hour'               }
      let(:different_hour)     { double 'different_hour'     }
      let(:now)                { double 'now'                }

      RespondsTo :post do
        When 'no hours have been posted' do
          ByReturning true do
            expect(filer)
              .to receive(:read)
              .and_return(nil)

            expect(journal_entry)
              .to receive(:hash_for)
              .with(hour, now)
              .and_return(journal_entry_hash)

            expect(filer)
              .to receive(:write)
              .with(hour)

            expect(subledger)
              .to receive(:journal_entry)
              .and_return(sl_journal_entry)

            expect(sl_journal_entry)
              .to receive(:create_and_post)
              .with(journal_entry_hash)

            subject.post(hour, now).must_equal true
          end
        end

        When 'the hour has not been posted' do
          ByReturning true do
            expect(filer)
              .to receive(:read)
              .and_return(different_hour)

            expect(hour_klass)
              .to receive(:new)
              .with(time: different_hour)
              .and_return(different_hour)

            expect(journal_entry)
              .to receive(:hash_for)
              .with(hour, now)
              .and_return(journal_entry_hash)

            expect(subledger)
              .to receive(:journal_entry)
              .and_return(sl_journal_entry)

            expect(sl_journal_entry)
              .to receive(:create_and_post)
              .with(journal_entry_hash)

            expect(filer)
              .to receive(:write)
              .with(hour)

            subject.post(hour, now).must_equal true
          end
        end

        When 'the hour has been posted' do
          ByReturning false do
            expect(filer)
              .to receive(:read)
              .and_return(hour)

            expect(hour_klass)
              .to receive(:new)
              .with(time: hour)
              .and_return(hour)

            subject.post(hour, now).must_equal false
          end
        end
      end
    end
  end
end
