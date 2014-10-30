# -*- encoding : utf-8 -*-
require 'helpers'

require 'instance_accountant/hour'

module InstanceAccountant
  Class Hour do
    Instance do
      subject { Hour.new options }

      let(:options) do
        {
          time_klass: time_klass
        }
      end

      let(:time_klass)  { double 'time_klass'     }

      let(:time_local)  { double 'time_local'     }
      let(:time_utc)    { double 'time_utc'       }
      let(:time_iso)    { double 'time_iso'       }
      let(:hour_string) { double 'hour_string'    }

      let(:other_hour)        { double 'other_hour'        }
      let(:other_hour_string) { double 'other_hour_string' }

      let(:other_time_local)  { double 'other_time_local'  }
      let(:other_time_utc)    { double 'other_time_utc'    }
      let(:other_time_iso)    { double 'other_time_iso'    }

      RespondsTo :to_s do
        ByReturning 'an hour string' do
          expect(time_klass)
            .to receive(:now)
            .and_return(time_local)

          expect(time_local)
            .to receive(:utc)
            .and_return(time_utc)

          expect(time_utc)
            .to receive(:iso8601)
            .and_return(time_iso)

          subject.to_s.must_equal time_iso
        end
      end

      RespondsTo :hour_string do
        ByReturning 'an hour string' do
          expect(time_klass)
            .to receive(:now)
            .and_return(time_local)

          expect(time_local)
            .to receive(:utc)
            .and_return(time_utc)

          expect(time_utc)
            .to receive(:iso8601)
            .and_return('2014-11-05T00')

          subject.hour_string.must_equal '2014-11-05T00:00:00Z'
        end
      end

      RespondsTo :== do
        When 'other is equal' do
          ByReturning true do

            expect(time_klass)
              .to receive(:now)
              .and_return(time_local)

            expect(time_local)
              .to receive(:utc)
              .and_return(time_utc)

            expect(time_utc)
              .to receive(:iso8601)
              .and_return(time_iso)

            expect(time_iso)
              .to receive(:[])
              .with(0..12)
              .and_return(hour_string)

            expect(other_hour)
              .to receive(:hour_string)
              .and_return(hour_string)

            expect(hour_string)
              .to receive(:+)
              .with(':00:00Z')
              .and_return(hour_string)

            (subject == other_hour).must_equal true
          end
        end

        When 'other is not equal' do
          ByReturning false do

            expect(time_klass)
              .to receive(:now)
              .and_return(time_local)

            expect(time_local)
              .to receive(:utc)
              .and_return(time_utc)

            expect(time_utc)
              .to receive(:iso8601)
              .and_return(time_iso)

            expect(time_iso)
              .to receive(:[])
              .with(0..12)
              .and_return(hour_string)

            expect(hour_string)
              .to receive(:+)
              .with(':00:00Z')
              .and_return(hour_string)

            expect(other_hour)
              .to receive(:hour_string)
              .and_return(other_hour_string)

            (subject == other_hour).must_equal false
          end
        end
      end
    end
  end
end
